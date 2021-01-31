const stripeToken = document.querySelector("meta[name='stripe-key']").getAttribute('content')

export default {
  mounted () {
    this.handleEvent('sessionRedirect', ({ session_id }) => {
      const stripe = Stripe(stripeToken)
      return stripe.redirectToCheckout({ sessionId: session_id })
    })
  }
}
