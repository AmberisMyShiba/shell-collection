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
