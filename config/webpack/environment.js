const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const erb = require('./loaders/erb')
const vue = require('./loaders/vue')

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.append('erb', erb)
environment.loaders.prepend('vue', vue)
module.exports = environment
