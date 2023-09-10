#!/bin/bash
RED='\033[0;31m'
GRN='\033[0;32m'
BLU='\033[0;34m'
NC='\033[0m'
echo ""
echo -e "Auto Tools for MacOS"
echo ""
PS3='Vui lòng nhập lựa chọn của bạn: '
options=("Bỏ qua MDM sau khi khôi phục" "Tắt thông báo (SIP)" "Tắt thông báo (Recovery)" "Kiểm tra đăng ký MDM" "Thoát")
select opt in "${options[@]}"; do
    case $opt in

    "Bỏ qua MDM sau khi khôi phục")
        echo -e "${GRN}Bỏ Qua MDM Sau Khi Khôi Phục"
        if [ -d "/Volumes/Macintosh HD - Data" ]; then
            diskutil rename "Macintosh HD - Data" "Data"
        fi
        echo -e "${GRN}Tạo người dùng mới"
        echo -e "${BLU}Nhấn Enter để chuyển bước tiếp theo. Nếu không điền, sẽ tự động nhận giá trị mặc định"
        echo -e "Nhập tên người dùng hiển thị (Mặc định: Mac Book), có thể có dấu cách"
        read realName
        realName="${realName:=Mac Book}"
        echo -e "${BLUE}Nhận username ${RED}VIẾT LIỀN KHÔNG DẤU ${GRN} (Mặc định: macbook)"
        read username
        username="${username:=macbook}"
        echo -e "${BLUE}Nhập password (Mặc định: 12345)"
        read passw
        passw="${passw:=12345}"
        dscl_path='/Volumes/Data/private/var/db/dslocal/nodes/Default'
        echo -e "${GREEN}Đang tạo user"
        # Create user
        dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username"
        dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UserShell "/bin/zsh"
        dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" RealName "$realName"
        dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" RealName "$realName"
        dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UniqueID "501"
        dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" PrimaryGroupID "20"
        mkdir "/Volumes/Data/Users/$username"
        dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" NFSHomeDirectory "/Users/$username"
        dscl -f "$dscl_path" localhost -passwd "/Local/Default/Users/$username" "$passw"
        dscl -f "$dscl_path" localhost -append "/Local/Default/Groups/admin" GroupMembership $username
        echo "0.0.0.0 deviceenrollment.apple.com" >>/Volumes/Macintosh\ HD/etc/hosts
        echo "0.0.0.0 mdmenrollment.apple.com" >>/Volumes/Macintosh\ HD/etc/hosts
        echo "0.0.0.0 iprofiles.apple.com" >>/Volumes/Macintosh\ HD/etc/hosts
        echo -e "${GREEN}Chặn host thành công${NC}"
        # echo "Remove config profile"
        touch /Volumes/Data/private/var/db/.AppleSetupDone
        rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
        rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
        touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
        touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound
        echo "----------------------"
        break
        ;;

    "Tắt thông báo (SIP)")
        echo -e "${RED}Vui lòng nhập mật khẩu của bạn để tiếp tục${NC}"
        sudo rm /var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
        sudo rm /var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
        sudo touch /var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
        sudo touch /var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound
        break
        ;;

    "Tắt thông báo (Recovery)")
        rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
        rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
        touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
        touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound
        break
        ;;

    "Kiểm tra đăng ký MDM")
        echo ""
        echo -e "${GRN}Kiểm tra đăng ký MDM. Nếu lỗi là Bỏ qua MDM thành công${NC}"
        echo ""
        echo -e "${RED}Vui lòng nhập mật khẩu của bạn để tiếp tục${NC}"
        echo ""
        sudo profiles show -type enrollment
        break
        ;;

    "Thoát")
        break
        ;;

    *) echo "Lựa chọn $REPLY không hợp lệ" ;;
    esac
done