// These two are the default empty implementations for exception handlers
export fn blockingHandler() void {
    while (true) {}
}

export fn nullHandler() void {}

// This comes from the linker script and represents the initial stack pointer address.
// Not a function, but pretend it is to suppress type error
extern fn _estack() void;

// These are the exception handlers, which are weakly linked to the default handlers
// in the linker script
extern fn Reset_Handler() void;
extern fn nmiHandler() void;
extern fn hardFaultHandler() void;
extern fn memoryManagementFaultHandler() void;
extern fn busFaultHandler() void;
extern fn usageFaultHandler() void;
extern fn svCallHandler() void;
extern fn debugMonitorHandler() void;
extern fn pendSVHandler() void;
extern fn sysTickHandler() void;

// The vector table
// const vector_table linksection(".isr_vector") = [_]?fn () callconv(.C) void{
//     _estack,
//     Reset_Handler, // Reset
//     nmiHandler, // NMI
//     hardFaultHandler, // Hard fault
//     memoryManagementFaultHandler, // Memory management fault
//     busFaultHandler, // Bus fault
//     usageFaultHandler, // Usage fault
//     null, // Reserved 1
//     null, // Reserved 2
//     null, // Reserved 3
//     null, // Reserved 4
//     svCallHandler, // SVCall
//     debugMonitorHandler, // Debug monitor
//     null, // Reserved 5
//     pendSVHandler, // PendSV
//     sysTickHandler, // SysTick
// };

// export const vt linksection(".isr_vector") = &vector_table;

const vector2 = packed struct {
  _estack: *const fn ()  callconv(.C) void,
  Reset_Handler: *const fn () callconv(.C) void,
};

export const vec linksection(".isr_vector") = vector2{
    ._estack = _estack,
    .Reset_Handler = Reset_Handler,
};

const vector = packed struct {
  _estack: fn () callconv(.C) void,
  Reset_Handler: fn () callconv(.C) void,

  NMI_Handler: fn () callconv(.C) void,
  HardFault_Handler: fn () callconv(.C) void,
  MemManage_Handler: fn () callconv(.C) void,
  BusFault_Handler: fn () callconv(.C) void,
  UsageFault_Handler: fn () callconv(.C) void,
  res0: ?*void,
  res1: ?*void,
  res2: ?*void,
  res3: ?*void,
  SVC_Handler: fn () callconv(.C) void,
  DebugMon_Handler: fn () callconv(.C) void,
  res4: ?*void,
  PendSV_Handler: fn () callconv(.C) void,
  SysTick_Handler: fn () callconv(.C) void,

  // External Interrupts */
  WWDG_IRQHandler: fn () callconv(.C) void,                   // Window WatchDog              */
  PVD_IRQHandler: fn () callconv(.C) void,                    // PVD through EXTI Line detection */
  TAMP_STAMP_IRQHandler: fn () callconv(.C) void,             // Tamper and TimeStamps through the EXTI line */
  RTC_WKUP_IRQHandler: fn () callconv(.C) void,               // RTC Wakeup through the EXTI line */
  FLASH_IRQHandler: fn () callconv(.C) void,                  // FLASH                        */
  RCC_IRQHandler: fn () callconv(.C) void,                    // RCC                          */
  EXTI0_IRQHandler: fn () callconv(.C) void,                  // EXTI Line0                   */
  EXTI1_IRQHandler: fn () callconv(.C) void,                  // EXTI Line1                   */
  EXTI2_IRQHandler: fn () callconv(.C) void,                  // EXTI Line2                   */
  EXTI3_IRQHandler: fn () callconv(.C) void,                  // EXTI Line3                   */
  EXTI4_IRQHandler: fn () callconv(.C) void,                  // EXTI Line4                   */
  DMA1_Stream0_IRQHandler: fn () callconv(.C) void,           // DMA1 Stream 0                */
  DMA1_Stream1_IRQHandler: fn () callconv(.C) void,           // DMA1 Stream 1                */
  DMA1_Stream2_IRQHandler: fn () callconv(.C) void,           // DMA1 Stream 2                */
  DMA1_Stream3_IRQHandler: fn () callconv(.C) void,           // DMA1 Stream 3                */
  DMA1_Stream4_IRQHandler: fn () callconv(.C) void,           // DMA1 Stream 4                */
  DMA1_Stream5_IRQHandler: fn () callconv(.C) void,           // DMA1 Stream 5                */
  DMA1_Stream6_IRQHandler: fn () callconv(.C) void,           // DMA1 Stream 6                */
  ADC_IRQHandler: fn () callconv(.C) void,                    // ADC1, ADC2 and ADC3s         */
  CAN1_TX_IRQHandler: fn () callconv(.C) void,                // CAN1 TX                      */
  CAN1_RX0_IRQHandler: fn () callconv(.C) void,               // CAN1 RX0                     */
  CAN1_RX1_IRQHandler: fn () callconv(.C) void,               // CAN1 RX1                     */
  CAN1_SCE_IRQHandler: fn () callconv(.C) void,               // CAN1 SCE                     */
  EXTI9_5_IRQHandler: fn () callconv(.C) void,                // External Line[9:5]s          */
  TIM1_BRK_TIM9_IRQHandler: fn () callconv(.C) void,          // TIM1 Break and TIM9          */
  TIM1_UP_TIM10_IRQHandler: fn () callconv(.C) void,          // TIM1 Update and TIM10        */
  TIM1_TRG_COM_TIM11_IRQHandler: fn () callconv(.C) void,     // TIM1 Trigger and Commutation and TIM11 */
  TIM1_CC_IRQHandler: fn () callconv(.C) void,                // TIM1 Capture Compare         */
  TIM2_IRQHandler: fn () callconv(.C) void,                   // TIM2                         */
  TIM3_IRQHandler: fn () callconv(.C) void,                   // TIM3                         */
  TIM4_IRQHandler: fn () callconv(.C) void,                   // TIM4                         */
  I2C1_EV_IRQHandler: fn () callconv(.C) void,                // I2C1 Event                   */
  I2C1_ER_IRQHandler: fn () callconv(.C) void,                // I2C1 Error                   */
  I2C2_EV_IRQHandler: fn () callconv(.C) void,                // I2C2 Event                   */
  I2C2_ER_IRQHandler: fn () callconv(.C) void,                // I2C2 Error                   */
  SPI1_IRQHandler: fn () callconv(.C) void,                   // SPI1                         */
  SPI2_IRQHandler: fn () callconv(.C) void,                   // SPI2                         */
  USART1_IRQHandler: fn () callconv(.C) void,                 // USART1                       */
  USART2_IRQHandler: fn () callconv(.C) void,                 // USART2                       */
  USART3_IRQHandler: fn () callconv(.C) void,                 // USART3                       */
  EXTI15_10_IRQHandler: fn () callconv(.C) void,              // External Line[15:10]s        */
  RTC_Alarm_IRQHandler: fn () callconv(.C) void,              // RTC Alarm (A and B) through EXTI Line */
  OTG_FS_WKUP_IRQHandler: fn () callconv(.C) void,            // USB OTG FS Wakeup through EXTI line */
  TIM8_BRK_TIM12_IRQHandler: fn () callconv(.C) void,         // TIM8 Break and TIM12         */
  TIM8_UP_TIM13_IRQHandler: fn () callconv(.C) void,          // TIM8 Update and TIM13        */
  TIM8_TRG_COM_TIM14_IRQHandler: fn () callconv(.C) void,     // TIM8 Trigger and Commutation and TIM14 */
  TIM8_CC_IRQHandler: fn () callconv(.C) void,                // TIM8 Capture Compare         */
  DMA1_Stream7_IRQHandler: fn () callconv(.C) void,           // DMA1 Stream7                 */
  FMC_IRQHandler: fn () callconv(.C) void,                    // FMC                          */
  SDMMC1_IRQHandler: fn () callconv(.C) void,                 // SDMMC1                       */
  TIM5_IRQHandler: fn () callconv(.C) void,                   // TIM5                         */
  SPI3_IRQHandler: fn () callconv(.C) void,                   // SPI3                         */
  UART4_IRQHandler: fn () callconv(.C) void,                  // UART4                        */
  UART5_IRQHandler: fn () callconv(.C) void,                  // UART5                        */
  TIM6_DAC_IRQHandler: fn () callconv(.C) void,               // TIM6 and DAC1&2 underrun errors */
  TIM7_IRQHandler: fn () callconv(.C) void,                   // TIM7                         */
  DMA2_Stream0_IRQHandler: fn () callconv(.C) void,           // DMA2 Stream 0                */
  DMA2_Stream1_IRQHandler: fn () callconv(.C) void,           // DMA2 Stream 1                */
  DMA2_Stream2_IRQHandler: fn () callconv(.C) void,           // DMA2 Stream 2                */
  DMA2_Stream3_IRQHandler: fn () callconv(.C) void,           // DMA2 Stream 3                */
  DMA2_Stream4_IRQHandler: fn () callconv(.C) void,           // DMA2 Stream 4                */
  ETH_IRQHandler: fn () callconv(.C) void,                    // Ethernet                     */
  ETH_WKUP_IRQHandler: fn () callconv(.C) void,               // Ethernet Wakeup through EXTI line */
  CAN2_TX_IRQHandler: fn () callconv(.C) void,                // CAN2 TX                      */
  CAN2_RX0_IRQHandler: fn () callconv(.C) void,               // CAN2 RX0                     */
  CAN2_RX1_IRQHandler: fn () callconv(.C) void,               // CAN2 RX1                     */
  CAN2_SCE_IRQHandler: fn () callconv(.C) void,               // CAN2 SCE                     */
  OTG_FS_IRQHandler: fn () callconv(.C) void,                 // USB OTG FS                   */
  DMA2_Stream5_IRQHandler: fn () callconv(.C) void,           // DMA2 Stream 5                */
  DMA2_Stream6_IRQHandler: fn () callconv(.C) void,           // DMA2 Stream 6                */
  DMA2_Stream7_IRQHandler: fn () callconv(.C) void,           // DMA2 Stream 7                */
  USART6_IRQHandler: fn () callconv(.C) void,                 // USART6                       */
  I2C3_EV_IRQHandler: fn () callconv(.C) void,                // I2C3 event                   */
  I2C3_ER_IRQHandler: fn () callconv(.C) void,                // I2C3 error                   */
  OTG_HS_EP1_OUT_IRQHandler: fn () callconv(.C) void,         // USB OTG HS End Point 1 Out   */
  OTG_HS_EP1_IN_IRQHandler: fn () callconv(.C) void,          // USB OTG HS End Point 1 In    */
  OTG_HS_WKUP_IRQHandler: fn () callconv(.C) void,            // USB OTG HS Wakeup through EXTI */
  OTG_HS_IRQHandler: fn () callconv(.C) void,                 // USB OTG HS                   */
  DCMI_IRQHandler: fn () callconv(.C) void,                   // DCMI                         */
  res5: ?*void,
  RNG_IRQHandler: fn () callconv(.C) void,                    // RNG                          */
  FPU_IRQHandler: fn () callconv(.C) void,                    // FPU                          */
  UART7_IRQHandler: fn () callconv(.C) void,                  // UART7                        */
  UART8_IRQHandler: fn () callconv(.C) void,                  // UART8                        */
  SPI4_IRQHandler: fn () callconv(.C) void,                   // SPI4                         */
  SPI5_IRQHandler: fn () callconv(.C) void,                   // SPI5                         */
  SPI6_IRQHandler: fn () callconv(.C) void,                   // SPI6                         */
  SAI1_IRQHandler: fn () callconv(.C) void,                   // SAI1                         */
  LTDC_IRQHandler: fn () callconv(.C) void,                   // LTDC                         */
  LTDC_ER_IRQHandler: fn () callconv(.C) void,                // LTDC error                   */
  DMA2D_IRQHandler: fn () callconv(.C) void,                  // DMA2D                        */
  SAI2_IRQHandler: fn () callconv(.C) void,                   // SAI2                         */
  QUADSPI_IRQHandler: fn () callconv(.C) void,                // QUADSPI                      */
  LPTIM1_IRQHandler: fn () callconv(.C) void,                 // LPTIM1                       */
  CEC_IRQHandler: fn () callconv(.C) void,                    // HDMI_CEC                     */
  I2C4_EV_IRQHandler: fn () callconv(.C) void,                // I2C4 Event                   */
  I2C4_ER_IRQHandler: fn () callconv(.C) void,                // I2C4 Error                   */
  SPDIF_RX_IRQHandler: fn () callconv(.C) void,               // SPDIF_RX                     */
  res6: *?void,
  DFSDM1_FLT0_IRQHandler: fn () callconv(.C) void,            // DFSDM1 Filter 0 global Interrupt */
  DFSDM1_FLT1_IRQHandler: fn () callconv(.C) void,            // DFSDM1 Filter 1 global Interrupt */
  DFSDM1_FLT2_IRQHandler: fn () callconv(.C) void,            // DFSDM1 Filter 2 global Interrupt */
  DFSDM1_FLT3_IRQHandler: fn () callconv(.C) void,            // DFSDM1 Filter 3 global Interrupt */
  SDMMC2_IRQHandler: fn () callconv(.C) void,                 // SDMMC2                       */
  CAN3_TX_IRQHandler: fn () callconv(.C) void,                // CAN3 TX                      */
  CAN3_RX0_IRQHandler: fn () callconv(.C) void,               // CAN3 RX0                     */
  CAN3_RX1_IRQHandler: fn () callconv(.C) void,               // CAN3 RX1                     */
  CAN3_SCE_IRQHandler: fn () callconv(.C) void,               // CAN3 SCE                     */
  JPEG_IRQHandler: fn () callconv(.C) void,                   // JPEG                         */
  MDIOS_IRQHandler: fn () callconv(.C) void,                  // MDIOS                        */
};
