function update --description 'Update Arch Linux system packages (pacman and yay)'
    command sudo pacman -Syu && command yay -Syu
end