package interview.repository

import interview.domain._

import scala.collection.mutable.{Buffer, ListBuffer}

trait OrderRepository {

  val orders: Buffer[Order]

  def findOpen: Seq[Order] = orders.filter(_.status == Some(Open)).readOnly

  def findExecuted: Seq[Order] = orders.filter(_.status == Some(Executed)).readOnly

  def findOpenByRicAndDirection(ric: Ric, direction: Direction): Seq[Order] =
    findOpen.filter(o => o.ric == ric && o.direction == direction)

  def findExecutedByRic(ric: Ric): Seq[Order] =
    findExecuted.filter(o => o.ric == ric)

  def findSellExecutedByRicAndUser(ric: Ric, user: String): Seq[Order] =
    findExecuted.filter(o => o.direction == Sell && o.ric == ric && o.user == user)

  def findBuyExecutedByRicAndUser(ric: Ric, user: String): Seq[Order] =
    findExecuted.filter(o => o.direction == Buy && o.ric == ric && o.user == user)

  def addOrder(order: Order): Order = {
    orders += order
    order
  }

  def updateOrder(order: Order): Order  = {
    val toRemove = orders.filter(_.id == order.id).head
    orders -= toRemove
    orders += order
    order
  }

}

object OrderRepository extends OrderRepository {
  override val orders: Buffer[Order] = ListBuffer[Order]()
}