import '../styles/app.scss'

import 'phoenix_html'
import { Socket } from 'phoenix'
import NProgress from 'nprogress'
import { LiveSocket } from 'phoenix_live_view'

const hooks = {}

hooks.link = {
  mounted () {
    this.el.addEventListener('click', (e) => {
      const attributeList = Object.entries(e.target.attributes)
        .map(([, a]) => a)
        .filter((a) => a.name.startsWith('phx-value-'))
        .map((a) => ([a.name.replace('phx-value-', ''), a.value]))

      const attributes = Object.fromEntries(attributeList)

      this.pushEvent(e.target.attributes.getNamedItem('phx-click').value, attributes)

      e.preventDefault()
      e.stopPropagation()
    })
  }
}

const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute('content')
const liveSocket = new LiveSocket('/live', Socket, { hooks, params: { _csrf_token: csrfToken } })

NProgress.configure({ showSpinner: false })

window.addEventListener('phx:page-loading-start', info => NProgress.start())
window.addEventListener('phx:page-loading-stop', info => NProgress.done())

liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket
