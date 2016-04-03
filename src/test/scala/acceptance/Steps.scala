package acceptance

import cucumber.api.DataTable
import cucumber.api.scala.{EN, ScalaDsl}
import interview.ExchangeSystem
import interview.domain.{Buy, Order, Sell}
import org.scalatest.Matchers

import scala.collection.JavaConverters._
import scala.collection.mutable.ListBuffer

object World {
  var es: Option[ExchangeSystem] = None
}

class Steps extends ScalaDsl with EN with Matchers {

  Given("""^The exchange system is empty$""") { () =>
    World.es = Some(
      new ExchangeSystem {
        override val open: ListBuffer[Order] = ListBuffer[Order]()
        override val executed: ListBuffer[Order] = ListBuffer[Order]()
      }
    )
  }

  Given("""^The exchange system contains:$""") { (state: DataTable) =>
    val (openOrders, executedOrders) = createExchangeSystem(state)
    World.es = Some(
      new ExchangeSystem {
        override val open: ListBuffer[Order] = openOrders
        override val executed: ListBuffer[Order] = executedOrders
      }
    )
  }

  When("""^I add a new order:$""") { (orders: DataTable) =>
    createOrders(orders).foreach(World.es.get.addOrder(_))
  }

  Then("""^The open orders contains the following orders:$""") { (orders: DataTable) =>
    World.es.get.open shouldBe createOrders(orders)
  }

  Then("""^The executed orders contains the following orders:$""") { (orders: DataTable) =>
    World.es.get.executed shouldBe createOrders(orders)
  }

  Then("""^There are no execute orders$""") { () =>
    World.es.get.executed shouldBe Seq[Order]()
  }

  When("""^There are no open orders$""") { () =>
    World.es.get.open shouldBe Seq[Order]()
  }

  Then("""^The Open interest for '(.*)' and '(.*)' is:$""") { (ric: String, direction: String, orders: DataTable) =>
    World.es.get.openInterest(ric, buildDirection(direction)) shouldBe createOrders(orders)
  }

  Then("""^The Average execution for '(.*)' is (.*)$""") { (ric: String, avrg: String) =>
    World.es.get.averageExcution(ric) shouldBe BigDecimal(avrg)
  }
  Then("""^The Executed quantity for '(.*)' and '(.*)' is (.*)$""") { (ric: String, user: String, execQuantity: String) =>
    World.es.get.executedQuantity(ric, user) shouldBe BigDecimal(execQuantity)
  }

  private def buildDirection(direction: String) =
    direction match {
      case "BUY" => Buy
      case "SELL" => Sell
      case _ => sys.error("Direction not defined")
    }

  private def buildOrder(o: scala.collection.mutable.Map[String, String]) = Order(
    direction = buildDirection(o("Direction")),
    ric = o("RIC"),
    quantity = o("Quantity").toLong,
    price = BigDecimal(o("Price")),
    user = o("User")
  )

  private def createOrders(open: DataTable): Seq[Order] = {
    val orders = open.asMaps(classOf[String], classOf[String]).asScala
    orders.map(o => buildOrder(o.asScala))
  }


  private def createExchangeSystem(state: DataTable): (ListBuffer[Order], ListBuffer[Order]) = {
    val open = ListBuffer[Order]()
    val executed = ListBuffer[Order]()
    val orders = state.asMaps(classOf[String], classOf[String]).asScala
    orders.map {
      o => o.get("Type") match {
        case "OPEN" => open += buildOrder(o.asScala)
        case "EXECUTED" => executed += buildOrder(o.asScala)
        case _ => sys.error("Type not defined")
      }

    }
    (open, executed)
  }
}
