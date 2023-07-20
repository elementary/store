const stripeToken = document.querySelector("meta[name='stripe-key']").getAttribute('content')

export default {
  mounted () {
    this.handleEvent('sessionRedirect', (params) => {
      const stripe = window.Stripe(stripeToken)
      return stripe.redirectToCheckout({ sessionId: params.session_id })
    })
  }
}
