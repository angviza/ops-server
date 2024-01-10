code=$(sed -z "s/\n/\\\n/g" code.txt)
data="{ \"inputCodeText\": \"$code\",\
    \"inputLang\": \"Kotlin\",\
    \"outputLang\": \"JavaScript\" }"
res=$(
    curl -X POST \
        -H 'Content-Type: application/json' \
        -H ':authority:www.codeconvert.ai' \
        -H ':path:/api/free-convert' \
        -H 'Accept:*/*' \
        -H 'Accept-Encoding:gzip, deflate, br' \
        -H 'Accept-Language:zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6' \
        -H 'Origin:https://www.codeconvert.ai' \
        -H 'Referer:https://www.codeconvert.ai/kotlin-to-java-converter' \
        -H 'Sec-Ch-Ua:'Not_A Brand';v='8', 'Chromium';v='120', 'Microsoft Edge';v='120'' \
        -H 'Sec-Ch-Ua-Mobile:?0' \
        -H 'Sec-Ch-Ua-Platform:'Windows'' \
        -H 'Sec-Fetch-Dest:empty' \
        -H 'Sec-Fetch-Mode:cors' \
        -H 'Sec-Fetch-Site:same-origin' \
        -H 'User-Agent:Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0' \
        -d "$data" \
        'https://www.codeconvert.ai/api/free-convert'
)
echo $res
resCode=$(echo $res | grep -oP "(?<=\"outputCodeText\":\")[^\"]*")
echo $resCode
# echo "=====$res"
# function jsonk_str() {
#     echo $(echo $1 | grep -oP "(?<=\"$2\":\")[^\"]*")
# }
