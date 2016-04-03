package interview.services

import interview.domain._
import interview.repository.OrderRepository

class ExchangeSystem(repo: OrderRepository) {

  def openOrders: Seq[Order] = repo.findOpen

  def executedOrders: Seq[Order] = repo.findExecuted

  def addOrder(order: Order): Order = {
    def toExecute(openOrder: Order, newOrder: Order) = {
      repo.updateOrder(openOrder.execute(newOrder.price))
      repo.addOrder(newOrder.execute)
    }

    def toOpen(newOrder: Order) = repo.addOrder(newOrder.open)

    val matchedOrders = repo.findOpen.filter(_.matching(order)).sortWith((o1, o2) => o1.price > o2.price)

    matchedOrders.size match {
      case 0 => toOpen(order)

      case 1 => toExecute(matchedOrders.head, order)

      case n if matchedOrders.filterNot(_.price == order.price).size == 0 =>
        toExecute(matchedOrders.head, order)

      case n if order.isSell => toExecute(matchedOrders.head, order)

      case n => toExecute(matchedOrders.last, order)
    }
  }

  def openInterest(ric: Ric, direction: Direction): Seq[Order] =
    repo.findOpenByRicAndDirection(ric, direction)

  def averageExcution(ric: Ric): BigDecimal = repo.findExecutedByRic(ric).map(_.price) match {
    case Nil => BigDecimal(0)
    case seq => seq.sum / seq.size
  }

  def executedQuantity(ric: Ric, user: String): BigDecimal = {
    val sellQuantity = repo.findSellExecutedByRicAndUser(ric, user).map(-_.quantity).sum
    val buyQuantity = repo.findBuyExecutedByRicAndUser(ric, user).map(_.quantity).sum
    sellQuantity + buyQuantity
  }

}

