# Wyatt 自己的 hosts 文件

ps: 脚本需要在 \*nix 下执行, 因为 curb 使用了 curl

## 五块内容:
* Google 服务
* Amazon 静态内容网站
* Apple 服务
* alibaba 中使用的 akamai cdn
* Adobe 屏蔽
* 广告屏蔽

外加在 Chrome 浏览器下使用 [HTTPS
Everywhere](https://chrome.google.com/webstore/detail/https-everywhere/gcbommkclmclpchllfjekcdonpmejbdp?hl=en-US) 速度刚刚滴


## 使用 (\*nix)
1. git clone git://github.com/wppurking/wyatt_hosts.git
2. cd wyatt_hosts
3. bundle install
4. ruby just-ping.rb
5. cp hosts.1[tab] /etc/hosts

That`s all
