# Terraform을 이용한 인프라 구성

## 환경 구성
1. WSL 설치 (powershell 관리자 권한으로 켠 후 입력)

```
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

## 재기동 후

wsl --install
```
2. aws cli 환경 구성 (wsl 환경에서 실행)  
* https://docs.aws.amazon.com/ko_kr/cli/latest/userguide/getting-started-install.html 
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```


