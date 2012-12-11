### 碎碎念
因为新学习 Rails 又趁着 RailsConfChina 2012, 所以本来是想试一下 Rails 将这个 hosts
获取编写成网络可访问, 并部署在 Clound Foundry 上, 因为使用了 mongoid 这个
gem, 结果无论如何调试都无法在 Cloud Foundry 上正常部署. 最后原因在
[mongoid 的官网](http://mongoid.org/en/mongoid/docs/tips.html)找到了,
需要使用到 ruby 1.9.3 版本才可以解决, 而 [Cloud
Foundry](http://www.cloudfoundry.com/) 上使用的最新的是 ruby 1.9.2. 

这个问题找到了, 但也已经没啥想法到 Cloud Foundry 上进行部署了,
不过项目是可用的, 在 VPS 上部署一个是不错的想法 ^\_^  哈哈.
