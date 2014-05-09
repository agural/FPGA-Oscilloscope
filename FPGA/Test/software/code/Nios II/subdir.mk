################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../char712.c \
../keyproc.c \
../lcdout.c \
../mainloop.c \
../menu.c \
../menuact.c \
../stubfncs.c \
../testcode.c \
../tracutil.c 

OBJS += \
./char712.o \
./keyproc.o \
./lcdout.o \
./mainloop.o \
./menu.o \
./menuact.o \
./stubfncs.o \
./testcode.o \
./tracutil.o 

C_DEPS += \
./char712.d \
./keyproc.d \
./lcdout.d \
./mainloop.d \
./menu.d \
./menuact.d \
./stubfncs.d \
./testcode.d \
./tracutil.d 


# Each subdirectory must supply rules for building sources it contributes
%.o: ../%.c
	@echo 'Building file: $<'
	@echo 'Invoking: Cygwin C Compiler'
	gcc -O2 -g -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


