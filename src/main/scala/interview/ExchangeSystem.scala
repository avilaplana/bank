package interview

import interview.domain.{Direction, Order, Sell}

import scala.collection.mutable.ListBuffer

trait ExchangeSystem {
  val open: ListBuffer[Order]
  val executed: ListBuffer[Order]

  def addOrder(newOrder: Order) = {
    def excuted(candidate: Order) = {
      open -= candidate
      executed += candidate.copy(price = newOrder.price)
      executed += newOrder
    }
    val matchingCandidates = open.filter(_.matching(newOrder)).sortWith((o1, o2) => o1.price > o2.price)
    matchingCandidates.size match {
      case 0 => open += newOrder
      case 1 => excuted(matchingCandidates.head)
      case n if matchingCandidates.filterNot(_.price == newOrder.price).size == 0 =>
        excuted(matchingCandidates.head)
      case n if newOrder.isSell => excuted(matchingCandidates.head)
      case n => excuted(matchingCandidates.last)
    }
  }

  def openInterest(ric: String, direction: Direction): Seq[Order] =
    open.filter(o => o.ric == ric && o.direction == direction)

  def averageExcution(ric: String): BigDecimal = {
    val o = executed.filter(o => o.ric == ric).map(_.price)
    o match {
      case ListBuffer() => BigDecimal(0)
      case _ => o.sum / o.size
    }
  }

  def executedQuantity(ric: String, user: String): BigDecimal = {
    val (sell, buy) = executed.filter(o => o.ric == ric && o.user == user).partition(_.direction == Sell)
    sell.map(_.quantity * -1).sum + buy.map(_.quantity).sum
  }

}

