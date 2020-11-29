const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute('content')

export default {
  DEBOUNCE_MS: 500,

  mounted () {
    this.el.addEventListener('submit', e => {
      e.preventDefault()

      const params = new URLSearchParams()
      for (let i = 0; i < this.el.length; i++) {
        const input = this.el[i]

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

      window.fetch(this.el.action, options)
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
    })
  }
}
