package interview.domain

import java.util.UUID

sealed trait Ric

case object VodL extends Ric

sealed trait Direction

case object Sell extends Direction

case object Buy extends Direction

sealed trait Status

case object Open extends Status

case object Executed extends Status

case class Order(direction: Direction,
                 ric: Ric,
                 quantity: Long,
                 price: BigDecimal,
                 user: String,
                 id: String = UUID.randomUUID().toString,
                 status: Option[Status] = None
                ) {
  def isSell = direction == Sell

  def isBuy = direction == Buy

  def open = this.copy(status = Some(Open))

  def execute = this.copy(status = Some(Executed))

  def execute(p: BigDecimal) = this.copy(price = p, status = Some(Executed))

  def matching(o: Order) = (direction, o.direction) match {
    case (Buy, Sell) if o.price <= price && o.ric == ric && o.quantity == quantity => true
    case (Sell, Buy) if price <= o.price && o.ric == ric && o.quantity == quantity => true
    case _ => false
  }
}

