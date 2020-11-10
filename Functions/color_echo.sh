##echo -e "\033[字背景颜色;字体颜色m字符串\033[控制码"
:<<!
\e后面为颜色设置部分“[32;40m\]”，32为前景色，40为背景色。“m\”不可少，色表如下：

F       B       颜色
30      40      黑色
31      41      红色
32      42      绿色
33      43      黄色
34      44      蓝色
35      45      紫红色
36      46      青蓝色
37      47      白色

输出特效格式控制：
\033[0m  关闭所有属性  
\033[1m   设置高亮度  
\03[4m   下划线  
\033[5m   闪烁  
\033[7m   反显  
\033[8m   消隐  
\033[30m   --   \033[37m   设置前景色  对照上面的色表 
\033[40m   --   \033[47m   设置背景色  对照上面的色表
！

## blue to echo 
function blue(){
    echo -e "\033[34m[ $1 ]\033[0m"
}


## green to echo 
function green(){
    echo -e "\033[32m[ $1 ]\033[0m"
}

## Error to warning with blink
function bred(){
    echo -e "\033[31m\033[01m\033[05m[ $1 ]\033[0m"
}

## Error to warning with blink
function byellow(){
    echo -e "\033[33m\033[01m\033[05m[ $1 ]\033[0m"
}


## Error
function bred(){
    echo -e "\033[31m\033[01m[ $1 ]\033[0m"
}

## warning
function byellow(){
    echo -e "\033[33m\033[01m[ $1 ]\033[0m"
}

## info
function Bred(){
    echo -e "\033[31m\033[01m[ $1 ]\033[0m"
}

## info
function Bgreen(){
    echo -e "\033[32m\033[01m[ $1 ]\033[0m"
}

