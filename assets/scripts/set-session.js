import debounce from 'lodash/debounce'

const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute('content')

export default {
  mounted () {
    const eventName = this.el.getAttribute('phx-hook-event') || 'submit'
    const timeout = this.el.getAttribute('phx-debounce') || 0
    const form = this.el.form || this.el

    const fn = debounce(() => {
      if (this.el.form != null && this.el.value === '') {
        return
      }

      const params = new URLSearchParams()
      for (let i = 0; i < form.length; i++) {
        const input = form[i]

        if (input.name != null && input.name !== '') {
          params.set(input.name, input.value)
        }
      }

      const options = {
        method: 'POST',
        mode: 'cors',
        cache: 'no-cache',
        credentials: 'same-origin',
        headers: {
          'Content-type': 'application/x-www-form-urlencoded',
          'x-csrf-token': csrfToken
        },
        body: params
      }

      window.fetch(form.action, options)
        .then((res) => {
          if (!res.ok) {
            console.error('Bad request made to server')
            window.reload()
          }
        })
        .catch((err) => {
          console.error(err)
          window.reload()
        })
    }, timeout)

    eventName.split(' ').forEach((evt) => {
      this.el.addEventListener(evt, (e) => {
        if (evt === 'submit') {
          e.preventDefault()
        }

        fn()
      })
    })
  }
}
