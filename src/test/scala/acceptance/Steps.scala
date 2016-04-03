package acceptance

import cucumber.api.DataTable
import cucumber.api.scala.{EN, ScalaDsl}
import interview.domain._
import interview.repository.OrderRepository
import interview.services.ExchangeSystem
import org.scalatest.Matchers

import scala.collection.JavaConverters._
import scala.collection.mutable._

object World {
  val map = HashMap.empty[String, ExchangeSystem]
}

class Steps extends ScalaDsl with EN with Matchers {

  Given("""^The exchange system is empty$""") { () =>
    World.map += "exchangeSystem" -> new ExchangeSystem(OrderRepository)
  }

  Given("""^The exchange system contains:$""") { (state: DataTable) =>
    World.map += "exchangeSystem" -> new ExchangeSystem(
      new OrderRepository {
        override val orders: Buffer[Order] = createExchangeSystem(state)
      }
    )
  }

  When("""^I add a new order:$""") { (orders: DataTable) =>
    createOrders(orders).foreach(World.map("exchangeSystem").addOrder(_))
  }

  Then("""^The open orders contains the following orders:$""") { (orders: DataTable) =>
    World.map("exchangeSystem").openOrders shouldBe createOrders(orders)
  }

  Then("""^The executed orders contains the following orders:$""") { (orders: DataTable) =>
    World.map("exchangeSystem").executedOrders shouldBe createOrders(orders)
  }

  Then("""^There are no execute orders$""") { () =>
    World.map("exchangeSystem").executedOrders shouldBe Seq[Order]()
  }

  When("""^There are no open orders$""") { () =>
    World.map("exchangeSystem").openOrders shouldBe Seq[Order]()
  }

  Then("""^The Open interest for '(.*)' and '(.*)' is:$""") { (ric: String, direction: String, orders: DataTable) =>
    World.map("exchangeSystem").openInterest(buildRic(ric), buildDirection(direction)) shouldBe createOrders(orders)
  }

  Then("""^The Average execution for '(.*)' is (.*)$""") { (ric: String, avrg: String) =>
    World.map("exchangeSystem").averageExcution(buildRic(ric)) shouldBe BigDecimal(avrg)
  }
  Then("""^The Executed quantity for '(.*)' and '(.*)' is (.*)$""") { (ric: String, user: String, execQuantity: String) =>
    World.map("exchangeSystem").executedQuantity(buildRic(ric), user) shouldBe BigDecimal(execQuantity)
  }

  private def buildDirection(direction: String) = direction match {
    case "BUY" => Buy
    case "SELL" => Sell
    case _ => sys.error("Direction not defined")
  }

  private def buildRic(ric: String) = ric match {
    case "VOD.L" => VodL
    case _ => sys.error("Ric not defined")
  }

  private def buildStatus(status: String) = status match {
    case "OPEN" => Open
    case "EXECUTED" => Executed
    case _ => sys.error("Status not defined")
  }


  private def buildOrder(o: scala.collection.mutable.Map[String, String]) = Order(
    direction = buildDirection(o("Direction")),
    ric = buildRic(o("RIC")),
    quantity = o("Quantity").toLong,
    price = BigDecimal(o("Price")),
    user = o("User"),
    id = o("ID"),
    status = o.get("Status").map(buildStatus(_))
  )

  private def createOrders(open: DataTable): Seq[Order] = {
    val orders = open.asMaps(classOf[String], classOf[String]).asScala
    orders.map(o => buildOrder(o.asScala))
  }

  private def createExchangeSystem(state: DataTable): Buffer[Order] = {
    val orders = state.asMaps(classOf[String], classOf[String]).asScala
    orders.map(o => buildOrder(o.asScala))
  }
}
