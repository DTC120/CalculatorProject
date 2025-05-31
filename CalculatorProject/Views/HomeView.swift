//
//  HomeView.swift
//  Calculator
//
//  Created by Diego Trejo on 26/05/25.
//

import SwiftUI

struct HomeView: View {
    
    @State var displayValue = "0"
    @State var computeValue = 0.0
    @State var currentOperator: Operation = .none
    
    let buttons: [[CalculatorButtons]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal]
    ]
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                    
                    ScrollViewReader { scrollProxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                                Text(displayValue)
                                    .bold()
                                    .font(.system(size: 100))
                                    .foregroundStyle(.white)
                                    .lineLimit(1)
                                    .id("scrollTarget")
                        }
                        .frame(height: 120)
                        .onChange(of: displayValue) { _ in
                            withAnimation {
                                scrollProxy.scrollTo("scrollTarget", anchor: .trailing)
                            }
                        }
                    }.padding()
                
                ForEach(buttons, id: \.self) { row in
                    
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button {
                                self.didTap(button: item)
                            } label: {
                                Text(item.rawValue)
                                    .font(.system(size: 32))
                                    .frame(width: self.buttonWidth(item: item), height: self.buttonHeight())
                                    .background(item.buttonColor)
                                    .clipShape(.rect(cornerRadius: self.buttonWidth(item: item) / 2))
                                    .foregroundStyle(Color.white)
                            }
                        }
                    }
                    .padding(.bottom, 3)
                }
            }
        }
    }
    
    func buttonWidth(item: CalculatorButtons) -> CGFloat {
        if item == .zero {
            return ((UIScreen.main.bounds.width - (4 * 12)) / 4) * 2
        }
        return (UIScreen.main.bounds.width - (5 * 12)) / 4
    }
    
    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5 * 12)) / 4
    }
    
    func didTap(button: CalculatorButtons) {
        switch button {
        case .add, .subtract, .multiply, .divide, .equal :
            if button  == .add {
                self.currentOperator = .add
                self.computeValue = Double(self.displayValue) ?? 0
            } else if button == .subtract {
                self.currentOperator = .subtract
                self.computeValue = Double(self.displayValue) ?? 0
            } else if button == .divide {
                self.currentOperator = .divide
                self.computeValue = Double(self.displayValue) ?? 0
            } else if button == .multiply {
                self.currentOperator = .multiply
                self.computeValue = Double(self.displayValue) ?? 0
            } else if button == .equal {
                let runningValue = self.computeValue
                let currentValue = Double(self.displayValue) ?? 0
                switch self.currentOperator {
                case .add:
                    self.displayValue = String(format: "%g", runningValue + currentValue)
                case .subtract:
                    self.displayValue = String(format: "%g", runningValue - currentValue)
                case .divide:
                    self.displayValue = String(format: "%g", runningValue / currentValue)
                case .multiply:
                    self.displayValue = String(format: "%g", runningValue * currentValue)
                case .none:
                    break
                }
            }
            
            if button != .equal {
                self.displayValue = "0"
            }
        case .clear:
            self.displayValue = "0"
            self.computeValue = 0.0
            self.currentOperator = .none
            
        case .decimal:
            // Evita múltiples puntos decimales
            if !self.displayValue.contains(".") {
                self.displayValue += "."
            }
            
        case .negative:
            // Alterna entre positivo y negativo
            if self.displayValue.hasPrefix("-") {
                self.displayValue.removeFirst()
            } else if self.displayValue != "0" {
                self.displayValue = "-" + self.displayValue
            }
            
        case .percent:
            // Convierte el número actual en porcentaje
            if let value = Double(self.displayValue) {
                self.displayValue = "\(value / 100)"
            }
            break
        default:
            let number = button.rawValue
            if self.displayValue == "0" {
                displayValue = number
            } else {
                self.displayValue = "\(self.displayValue)\(number)"
            }
        }
    }
}

#Preview {
    HomeView()
}
