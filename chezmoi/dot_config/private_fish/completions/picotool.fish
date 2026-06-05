# Fish shell completions for picotool
complete -c picotool -n __fish_is_first_arg -f # Disable file completion only when picotool is used without subcommands
### Main commands ###
complete -c picotool -n __fish_use_subcommand -a info -d "Display information from the target device(s) or file"
complete -c picotool -n __fish_use_subcommand -a config -d "Display or change program configuration settings"
complete -c picotool -n __fish_use_subcommand -a load -d "Load the program/memory range from a file onto the device"
complete -c picotool -n __fish_use_subcommand -a encrypt -d "Encrypt the program"
complete -c picotool -n __fish_use_subcommand -a seal -d "Add final metadata to a binary (e.g., hash/signature)"
complete -c picotool -n __fish_use_subcommand -a link -d "Link multiple binaries into one block loop"
complete -c picotool -n __fish_use_subcommand -a save -d "Save the program/memory from flash to a file"
complete -c picotool -n __fish_use_subcommand -a erase -d "Erase the program/memory stored in flash"
complete -c picotool -n __fish_use_subcommand -a verify -d "Check that device contents match the file"
complete -c picotool -n __fish_use_subcommand -a reboot -d "Reboot the device"
complete -c picotool -n __fish_use_subcommand -a otp -d "Commands for RP2350 OTP Memory"
complete -c picotool -n __fish_use_subcommand -a partition -d "Commands for RP2350 Partition Tables"
complete -c picotool -n __fish_use_subcommand -a uf2 -d "Commands for UF2 creation and status"
complete -c picotool -n __fish_use_subcommand -a version -d "Display picotool version"
complete -c picotool -n __fish_use_subcommand -a coprodis -d "Post-process coprocessor instructions in disassembly files"
complete -c picotool -n __fish_use_subcommand -a help -d "Show general help or help for a specific command"

### Global device selection options ###
complete -c picotool -n "__fish_not_contain_opt -s t type" -l bus -d "Filter devices by USB bus number" -x
complete -c picotool -n "__fish_not_contain_opt -s t type" -l address -d "Filter devices by USB device address" -x
complete -c picotool -n "__fish_not_contain_opt -s t type" -l vid -d "Filter by vendor id" -x
complete -c picotool -n "__fish_not_contain_opt -s t type" -l pid -d "Filter by product id" -x
complete -c picotool -n "__fish_not_contain_opt -s t type" -l ser -d "Filter by serial number" -x
complete -c picotool -n "__fish_not_contain_opt -s t type" -s f -l force -d "Force device not in BOOTSEL mode to reset"
complete -c picotool -n "__fish_not_contain_opt -s t type" -s F -l force-no-reboot -d "Force device reset without rebooting back"

### File type option ###
complete -c picotool -s t -d "Specify file type" -n "__fish_seen_subcommand_from info config load save verify encrypt seal link uf2" -a "uf2 elf bin pem json" -x

### 'info' command options ###
complete -c picotool -n "__fish_seen_subcommand_from info" -s b -l basic -d "Include basic information"
complete -c picotool -n "__fish_seen_subcommand_from info" -s m -l metadata -d "Include all metadata blocks"
complete -c picotool -n "__fish_seen_subcommand_from info" -s p -l pins -d "Include pin information"
complete -c picotool -n "__fish_seen_subcommand_from info" -s d -l device -d "Include device information"
complete -c picotool -n "__fish_seen_subcommand_from info" -l debug -d "Include device debug information"
complete -c picotool -n "__fish_seen_subcommand_from info" -s l -l build -d "Include build attributes"
complete -c picotool -n "__fish_seen_subcommand_from info" -s a -l all -d "Include all information"

### 'config' command options ###
complete -c picotool -n "__fish_seen_subcommand_from config" -s g -d "Filter by feature group" -x
complete -c picotool -n "__fish_seen_subcommand_from config" -s s -d "Set variable value" -x

### 'load' command options ###
complete -c picotool -n "__fish_seen_subcommand_from load" -l ignore-partitions -d "Ignore partition table and write to absolute space"
complete -c picotool -n "__fish_seen_subcommand_from load" -l family -d "Specify family ID of file to load" -x
complete -c picotool -n "__fish_seen_subcommand_from load" -s p -l partition -d "Specify partition to load into" -x
complete -c picotool -n "__fish_seen_subcommand_from load" -s n -l no-overwrite -d "Do not overwrite existing program in flash"
complete -c picotool -n "__fish_seen_subcommand_from load" -s N -l no-overwrite-unsafe -d "Do not overwrite existing program (unsafe)"
complete -c picotool -n "__fish_seen_subcommand_from load" -s u -l update -d "Skip writing flash sectors with identical data"
complete -c picotool -n "__fish_seen_subcommand_from load" -s v -l verify -d "Verify data was written correctly"
complete -c picotool -n "__fish_seen_subcommand_from load" -s x -l execute -d "Execute downloaded file as a program after load"
complete -c picotool -n "__fish_seen_subcommand_from load" -s o -l offset -d "Specify load address for BIN file" -x

### 'encrypt' command options ###
complete -c picotool -n "__fish_seen_subcommand_from encrypt" -l quiet -d "Don't print any output"
complete -c picotool -n "__fish_seen_subcommand_from encrypt" -l verbose -d "Print verbose output"
complete -c picotool -n "__fish_seen_subcommand_from encrypt" -l hash -d "Hash the encrypted file"
complete -c picotool -n "__fish_seen_subcommand_from encrypt" -l sign -d "Sign the encrypted file"
complete -c picotool -n "__fish_seen_subcommand_from encrypt" -s o -l offset -d "Specify load address for BIN file" -x

### 'seal' command options ###
complete -c picotool -n "__fish_seen_subcommand_from seal" -l quiet -d "Don't print any output"
complete -c picotool -n "__fish_seen_subcommand_from seal" -l verbose -d "Print verbose output"
complete -c picotool -n "__fish_seen_subcommand_from seal" -l hash -d "Hash the file"
complete -c picotool -n "__fish_seen_subcommand_from seal" -l sign -d "Sign the file"
complete -c picotool -n "__fish_seen_subcommand_from seal" -l clear -d "Clear all of SRAM on load"
complete -c picotool -n "__fish_seen_subcommand_from seal" -s o -l offset -d "Specify load address for BIN file" -x
complete -c picotool -n "__fish_seen_subcommand_from seal" -l major -d "Add Major Version" -x
complete -c picotool -n "__fish_seen_subcommand_from seal" -l minor -d "Add Minor Version" -x
complete -c picotool -n "__fish_seen_subcommand_from seal" -l rollback -d "Add Rollback Version" -x

### 'save' command options ###
complete -c picotool -n "__fish_seen_subcommand_from save" -s p -l program -d "Save the installed program only (default)"
complete -c picotool -n "__fish_seen_subcommand_from save" -s a -l all -d "Save all of flash memory"
complete -c picotool -n "__fish_seen_subcommand_from save" -s r -l range -d "Save a range of memory" -x
complete -c picotool -n "__fish_seen_subcommand_from save" -s v -l verify -d "Verify data was saved correctly"
complete -c picotool -n "__fish_seen_subcommand_from save" -l family -d "Specify family ID to save file as" -x

### 'erase' command options ###
complete -c picotool -n "__fish_seen_subcommand_from erase" -s a -l all -d "Erase all of flash memory (default)"
complete -c picotool -n "__fish_seen_subcommand_from erase" -s p -l partition -d "Erase a partition" -x
complete -c picotool -n "__fish_seen_subcommand_from erase" -s r -l range -d "Erase a range of memory" -x

### 'reboot' command options ###
complete -c picotool -n "__fish_seen_subcommand_from reboot" -s a -l app -d "Reboot to application mode (default)"
complete -c picotool -n "__fish_seen_subcommand_from reboot" -s u -l usb -d "Reboot to USB boot mode"
complete -c picotool -n "__fish_seen_subcommand_from reboot" -s g -l goto -d "Go to partition" -x
complete -c picotool -n "__fish_seen_subcommand_from reboot" -s c -l cpu -d "Specify CPU (0 for ARM, 1 for RISC-V)" -x

### 'otp' subcommands ###
complete -c picotool -n "__fish_seen_subcommand_from otp; and not __fish_seen_subcommand_from list get set load dump permissions white-label" -a list -d "List matching known registers/fields"
complete -c picotool -n "__fish_seen_subcommand_from otp; and not __fish_seen_subcommand_from list get set load dump permissions white-label" -a get -d "Get OTP registers/fields value"
complete -c picotool -n "__fish_seen_subcommand_from otp; and not __fish_seen_subcommand_from list get set load dump permissions white-label" -a set -d "Set OTP row/field value"
complete -c picotool -n "__fish_seen_subcommand_from otp; and not __fish_seen_subcommand_from list get set load dump permissions white-label" -a load -d "Load data from file into OTP"
complete -c picotool -n "__fish_seen_subcommand_from otp; and not __fish_seen_subcommand_from list get set load dump permissions white-label" -a dump -d "Dump entire OTP"
complete -c picotool -n "__fish_seen_subcommand_from otp; and not __fish_seen_subcommand_from list get set load dump permissions white-label" -a permissions -d "Set OTP access permissions"
complete -c picotool -n "__fish_seen_subcommand_from otp; and not __fish_seen_subcommand_from list get set load dump permissions white-label" -a white-label -d "Set white labelling values in OTP"

### 'otp list' options ###
complete -c picotool -n "__fish_seen_subcommand_from otp; and __fish_seen_subcommand_from list" -s p -d "Print permissions"
complete -c picotool -n "__fish_seen_subcommand_from otp; and __fish_seen_subcommand_from list" -s n -d "Print names"
complete -c picotool -n "__fish_seen_subcommand_from otp; and __fish_seen_subcommand_from list" -s f -d "Print field names"
complete -c picotool -n "__fish_seen_subcommand_from otp; and __fish_seen_subcommand_from list" -s i -d "Import OTP layout from JSON file" -r

### 'otp get/set' options ###
complete -c picotool -n "__fish_seen_subcommand_from otp; and __fish_seen_subcommand_from get set" -s c -d "Copies to read/write" -x
complete -c picotool -n "__fish_seen_subcommand_from otp; and __fish_seen_subcommand_from get set" -s r -d "Raw mode"
complete -c picotool -n "__fish_seen_subcommand_from otp; and __fish_seen_subcommand_from get set" -s e -d "ECC mode"
complete -c picotool -n "__fish_seen_subcommand_from otp; and __fish_seen_subcommand_from get set" -s i -d "Import OTP layout from JSON file" -r
complete -c picotool -n "__fish_seen_subcommand_from otp; and __fish_seen_subcommand_from get set" -s z -d "Zero rows before setting"
complete -c picotool -n "__fish_seen_subcommand_from otp; and __fish_seen_subcommand_from set" -s s -d "Skip verification"

### 'otp load' options ###
complete -c picotool -n "__fish_seen_subcommand_from otp; and __fish_seen_subcommand_from load" -s r -d "Raw mode"
complete -c picotool -n "__fish_seen_subcommand_from otp; and __fish_seen_subcommand_from load" -s e -d "ECC mode"
complete -c picotool -n "__fish_seen_subcommand_from otp; and __fish_seen_subcommand_from load" -s s -d "Starting row" -x
complete -c picotool -n "__fish_seen_subcommand_from otp; and __fish_seen_subcommand_from load" -s i -d "Import OTP layout from JSON file" -r

### 'otp permissions' options ###
complete -c picotool -n "__fish_seen_subcommand_from otp; and __fish_seen_subcommand_from permissions" -l led -d "LED Pin to flash (default 25)" -x
complete -c picotool -n "__fish_seen_subcommand_from otp; and __fish_seen_subcommand_from permissions" -l hash -d "Hash the executable"
complete -c picotool -n "__fish_seen_subcommand_from otp; and __fish_seen_subcommand_from permissions" -l sign -d "Sign the executable"

### 'otp white-label' options ###
complete -c picotool -n "__fish_seen_subcommand_from otp; and __fish_seen_subcommand_from white-label" -s s -d "Starting row" -x

### 'partition' subcommands ###
complete -c picotool -n "__fish_seen_subcommand_from partition; and not __fish_seen_subcommand_from info create" -a info -d "Print the device's partition table"
complete -c picotool -n "__fish_seen_subcommand_from partition; and not __fish_seen_subcommand_from info create" -a create -d "Create a partition table from JSON"

### 'partition info' options ###
complete -c picotool -n "__fish_seen_subcommand_from partition; and __fish_seen_subcommand_from info" -s m -d "Filter by family ID" -x

### 'partition create' options ###
complete -c picotool -n "__fish_seen_subcommand_from partition; and __fish_seen_subcommand_from create" -l quiet -d "Don't print any output"
complete -c picotool -n "__fish_seen_subcommand_from partition; and __fish_seen_subcommand_from create" -l verbose -d "Print verbose output"
complete -c picotool -n "__fish_seen_subcommand_from partition; and __fish_seen_subcommand_from create" -s o -l offset -d "Load address for UF2 output" -x
complete -c picotool -n "__fish_seen_subcommand_from partition; and __fish_seen_subcommand_from create" -l family -d "Family ID for UF2 output" -x
complete -c picotool -n "__fish_seen_subcommand_from partition; and __fish_seen_subcommand_from create" -l sign -d "Sign the partition table" -r
complete -c picotool -n "__fish_seen_subcommand_from partition; and __fish_seen_subcommand_from create" -l no-hash -d "Don't hash the partition table"
complete -c picotool -n "__fish_seen_subcommand_from partition; and __fish_seen_subcommand_from create" -l singleton -d "Singleton partition table"
complete -c picotool -n "__fish_seen_subcommand_from partition; and __fish_seen_subcommand_from create" -l abs-block -d "Enforce support for an absolute block"

### 'uf2' subcommands ###
complete -c picotool -n "__fish_seen_subcommand_from uf2; and not __fish_seen_subcommand_from info convert" -a info -d "Print info about UF2 download"
complete -c picotool -n "__fish_seen_subcommand_from uf2; and not __fish_seen_subcommand_from info convert" -a convert -d "Convert ELF/BIN to UF2"

### 'uf2 convert' options ###
complete -c picotool -n "__fish_seen_subcommand_from uf2; and __fish_seen_subcommand_from convert" -l quiet -d "Don't print any output"
complete -c picotool -n "__fish_seen_subcommand_from uf2; and __fish_seen_subcommand_from convert" -l verbose -d "Print verbose output"
complete -c picotool -n "__fish_seen_subcommand_from uf2; and __fish_seen_subcommand_from convert" -s o -l offset -d "Load address" -x
complete -c picotool -n "__fish_seen_subcommand_from uf2; and __fish_seen_subcommand_from convert" -l family -d "Family ID for UF2" -x
complete -c picotool -n "__fish_seen_subcommand_from uf2; and __fish_seen_subcommand_from convert" -l abs-block -d "Add an absolute block"

### 'version' command options ###
complete -c picotool -n "__fish_seen_subcommand_from version" -s s -d "Show only the version string" -f

### 'coprodis' command options ###
complete -c picotool -n "__fish_seen_subcommand_from coprodis" -l quiet -d "Don't print any output"
complete -c picotool -n "__fish_seen_subcommand_from coprodis" -l verbose -d "Print verbose output"

### 'help' command completions ###
complete -c picotool -n "__fish_seen_subcommand_from help" -a "info config load encrypt seal link save erase verify reboot otp partition uf2 version coprodis" -d "Command to get help for" -f
