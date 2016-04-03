package interview.domain

sealed trait Direction

case object Sell extends Direction

case object Buy extends Direction

case class Order(direction: Direction, ric: String, quantity: Long, price: BigDecimal, user: String) {
  def isSell = direction == Sell
  def isBuy = direction == Buy
  def matching(o: Order) = (this.direction, o.direction) match {
    case (Buy,Sell)
      if o.price <= this.price && o.ric == this.ric && o.quantity == this.quantity => true
    case (Sell, Buy)
      if this.price <= o.price && o.ric == this.ric && o.quantity == this.quantity => true
    case _ => false
  }
}

