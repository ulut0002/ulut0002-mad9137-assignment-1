    //
    //  ContentView.swift
    //  ulut0002-mad9137-assignment-1
    //
    //  Created by Serdar Ulutas on 2023-10-13.
    //

    import SwiftUI

    struct ContentView: View {
        // from: chatGPT
        @Environment(\.verticalSizeClass) var verticalSizeClass
        @Environment(\.horizontalSizeClass) var horizontalSizeClass
        
        // State variables with initial values
        @State var red: Double = 0
        @State var green: Double = 0
        @State var blue: Double = 0
        @State var alpha: Double = 255
        @State var color: Color = .black
        @State var rgbFieldText: String = ""
        
    

        
        // Action: User changes "textfield" value:
        // - Set "color" state variable
        // - Set r,g,b,a state variables
        func handleTextFieldChange(_ value: String) {
            let colorComponents = getRGBAColor(rgba: value)
            red = Double(colorComponents.0 )
            green = Double(colorComponents.1 )
            blue = Double(colorComponents.2)
            alpha = Double(colorComponents.3)
            color = Color(red: red / 255, green: green / 255, blue: blue / 255)
        }
        
        // Action: User changes slide
        // - Set "color" state variable
        // - Set r,g,b,a state variables
        // - Set textfield value accordingly
        func handleSliderChange() {
            color = Color(red: red / 255, green: green / 255, blue: blue / 255)
            
            // source: chatGPT
            let redColor = String(format: "%02X", Int(red))
            let greenColor = String(format: "%02X", Int(green))
            let blueColor = String(format: "%02X", Int(blue))
            let alphaValue = String(format: "%02X", Int(alpha))
            
            rgbFieldText = "\(redColor)\(greenColor)\(blueColor)\(alphaValue)"
        }
        
        // Action: User presses "Reset" button
        // - sets color values back to default values
        func handleReset () {
            red = 0.0
            green = 0.0
            blue = 0.0
            alpha = 255.0
            color = Color(red: red / 255, green: green / 255, blue: blue / 255)
        }
   
        // Main view function. 
        // Returns different views based on device orientation
        var body: some View {
            if horizontalSizeClass == .compact && verticalSizeClass == .regular {
                return AnyView(portraitView)
            }else{
                return AnyView(landscapeView)
            }
        }
        
        // Landscape view : 2 column-view
        // Left column: Preview and the textfield
        // Right column: Sliders and the Reset button
        var landscapeView: some View {
            return HStack{
                VStack{
                    Spacer()
                    ColorView(color: $color, opacity: $alpha)
                    TextFieldView(rgbFieldText: $rgbFieldText, handleTextFieldChange: handleTextFieldChange)
                    Spacer()
                }
                VStack{
                    Spacer()
                    SliderView(title: "Red", sliderColor: .red, value: $red, handleSliderChange: handleSliderChange)
                
                    SliderView(title: "Green",  sliderColor: .green, value: $green,handleSliderChange: handleSliderChange)
                    
                    SliderView(title: "Blue",  sliderColor: .blue, value: $blue,handleSliderChange: handleSliderChange)
                    
                    SliderView(title: "Alpha", sliderColor: .black, value: $alpha,handleSliderChange: handleSliderChange)
                    Spacer()
                    ResetButton(handleReset: handleReset)
                    Spacer()
                }.padding()
                
            }.onAppear(){
                // sets the textfield value in initial load
                handleSliderChange()
            }
         
            
        }
        
        // Portrait view : 1-column-view
        var portraitView: some View {
            return VStack {
                Spacer()
                TextFieldView(rgbFieldText: $rgbFieldText, handleTextFieldChange: handleTextFieldChange)
                ColorView(color: $color, opacity: $alpha)
                HStack{
                    // to add space
                }.padding()

               
                SliderView(title: "Red", sliderColor: .red, value: $red, handleSliderChange: handleSliderChange)
            
                SliderView(title: "Green",  sliderColor: .green, value: $green,handleSliderChange: handleSliderChange)
                
                SliderView(title: "Blue",  sliderColor: .blue, value: $blue,handleSliderChange: handleSliderChange)
                
                SliderView(title: "Alpha", sliderColor: .black, value: $alpha,handleSliderChange: handleSliderChange)
                
                Spacer()
                
                ResetButton(handleReset: handleReset)
            }.onAppear(){
                // sets the textfield value in initial load
                handleSliderChange()
            }
            .padding(20)
        }
   }





    struct SliderView: View {
        let title : String
        let sliderColor: Color
      
        @Binding var value: Double
        @State private var intValue : Int = 0
        var handleSliderChange: () -> Void

        var body: some View {
            VStack{
                Slider(
                    value : $value,
                    in: 0...255,
                    step: 1,
                    onEditingChanged:{ editing in
                            if (!editing){
                                intValue = Int(value)
                                handleSliderChange()
                            }
                        }
                ).accentColor(sliderColor)
                Text("\(title): \(intValue)").foregroundColor(sliderColor).font(.title3)
            }.onAppear() {
                intValue = Int(value)
            }.onChange(of: value){
                intValue = Int(value)
                //handleSliderChange()  do not enable. messes up with textfield value
            }
           
        }
    }



    struct TextFieldView: View {
        @Binding var rgbFieldText: String
        @State var isApplyButtonDisabled: Bool = true
        var handleTextFieldChange: (String) -> Void
        
        var body: some View {
            HStack{
                TextField("Color Code", text: $rgbFieldText)
                    .font(.title2)
                    .frame(width:150,height:20)
                    .textInputAutocapitalization(.characters)
                    .foregroundColor(.black)
                    .padding(.bottom)
                    .keyboardType(.default)
                    .background(.white)
                    .cornerRadius(10)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: rgbFieldText){
                        let sanitizedCopy = rgbFieldText.prefix(8).filter{isValidHexCharacter($0)}
                        
                        rgbFieldText = sanitizedCopy
                        
                        isApplyButtonDisabled = !(rgbFieldText.count == 3
                        || rgbFieldText.count == 4
                        || rgbFieldText.count == 6
                        || rgbFieldText.count == 8)
                        
                        handleTextFieldChange(rgbFieldText)
                        
                    }
                // no need for button because it automatically validates the text
//                Button("Apply"){
//                    handleTextFieldChange(rgbFieldTextCopy)
//                }.disabled(isApplyButtonDisabled)
            }.padding()
            
            
        }
    }

    // Displays a square rectangle shape with a variable foreground color and opacity
    struct ColorView: View {
        @Binding var color: Color
        @Binding var opacity: Double
        @Environment(\.horizontalSizeClass) var horizontalSizeClass
        @Environment(\.verticalSizeClass) var verticalSizeClass

        
        // This variable is from chatGPT
        var size: CGFloat {
               return horizontalSizeClass == .compact && verticalSizeClass == .regular  ? 300 : 200
        }
        var body: some View {
            HStack{
                Rectangle()
                    .frame(width: size, height: size)
                    .foregroundColor(color)
                    .opacity(opacity/255)
                    .cornerRadius(5)
            }.padding()
        }
    }

    // Reset button at the bottom. 
    struct ResetButton: View {
        var handleReset: () -> Void

        var body: some View {
            Button(action: {
                handleReset()
            }){
                Text("Reset")
            }
        }
    }


    #Preview {
        ContentView()
    }
