//
//  CollectStringFromBLE.swift
//  CityGNSS
//
//  Created by Tiago Maia on 12/07/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import Foundation
import UIKit

class CollectStringFromBLE {

    private var nmeaString:String!
    var hasStringNMEA: Bool!
    var isIncomplete: Bool!
    private var auxString:String!
   
    
    init() {
        hasStringNMEA = false
        isIncomplete = false
        nmeaString = ""
        auxString = ""
    }
    
    //work with string
    // start with '$' and terminate witjh '\n'
    func pushString(nmeaForString: String){
        //
        debugPrint("start CollectString ------------------------------------")

    
        if(isIncomplete && !auxString.isEmpty){
            nmeaString = auxString
            auxString = ""
            isIncomplete = false
        }
        
        if(nmeaForString.character(at: 0) == "$"){
            if(nmeaForString.contains("\r\n") || nmeaForString.contains("\n")){
                nmeaString = nmeaForString.removeCharacters(from: "\r\n")
            }else{
                nmeaString = nmeaForString
            }
        }
        else if(nmeaForString.contains("\r\n") || nmeaForString.contains("\n")){
            
            let lineArray = nmeaForString.split { $0 == "\n" || $0 == "\r\n" }.map(String.init)
            if(lineArray.count > 0){
                if(lineArray.count == 2){
                    if(lineArray[1].character(at: 0) == "$"){   // if found start of new setence
                        auxString = lineArray[1]             //save to next nmea setence
                        isIncomplete = true
                    }
                }
                // complete last part of setence
                if(!nmeaString.isEmpty){                        //complete nmea?
                    nmeaString.append(lineArray[0])
                }
            }
        }else{
//            if(!auxString.isEmpty){                          //middle part of setence
//                nmeaString = auxString
//                auxString = ""
//            }
            nmeaString.append(nmeaForString)
        }
        
        checkIfHasStringNMEA()
        debugPrint("stop CollectString ------------------------------------")

    }
    
    func pullString()->String{
        
        if hasStringNMEA{
            //one-by-one
            let aux = nmeaString!
            nmeaString = String.init() //reset
            hasStringNMEA = false
            return aux
        }
        return String.init()    //empty
    }
    
    
    
    func checkIfHasStringNMEA(){
        
        if(nmeaString.isEmpty){
            return
        }
        print("checkIfHasString \(nmeaString)")
        
        if( nmeaString[nmeaString.index(nmeaString.startIndex, offsetBy: 0)] == "$") && ( nmeaString[nmeaString.index(nmeaString.endIndex,  offsetBy: -3)] == "*"){
            
            hasStringNMEA = true
        }else{
            hasStringNMEA = false
        }
        print("checkIfHasString \(hasStringNMEA.description)")
    }
    
    

}


extension String {
    /// stringToFind must be at least 1 character.
    func countInstances(of stringToFind: String) -> Int {
        assert(!stringToFind.isEmpty)
        var count = 0
        var searchRange: Range<String.Index>?
        while let foundRange = range(of: stringToFind, options: [], range: searchRange) {
            count += 1
            searchRange = Range(uncheckedBounds: (lower: foundRange.upperBound, upper: endIndex))
        }
        return count
    }
    
    func index(at position: Int, from start: Index? = nil) -> Index? {
        let startingIndex = start ?? startIndex
        return index(startingIndex, offsetBy: position, limitedBy: endIndex)
    }
    
    func character(at position: Int) -> Character? {
        guard position >= 0, let indexPosition = index(at: position) else {
            return nil
        }
        return self[indexPosition]
    }
    
    func removeCharacters(from forbiddenChars: CharacterSet) -> String {
        let passed = self.unicodeScalars.filter { !forbiddenChars.contains($0) }
        return String(String.UnicodeScalarView(passed))
    }
    
    func removeCharacters(from: String) -> String {
        return removeCharacters(from: CharacterSet(charactersIn: from))
    }
    
}




/*
 
 let tok =  nmeaForString.countInstances(of: "$")
 
 debugPrint("tok=\(tok)")
 if tok == 2{    //found 2 setences nmea in same array
 
 //separate for another
 let lineArray = nmeaForString.split { $0 == "\n" || $0 == "\r\n" }.map(String.init)
 
 debugPrint(lineArray)
 
 }
 
 if tok == 1{
 
 if(nmeaForString.character(at: 0) == "$"){
 nmeaString = String(nmeaForString)
 if(nmeaForString.contains("\n")){
 let aux = nmeaForString.replacingOccurrences(of: "\r\n", with: "")
 if(isIncomplete){
 nmeaString.append(aux)
 }else{
 nmeaString = aux
 }
 hasStringNMEA = true
 return
 }
 }
 }
 
 isIncomplete = true
 
 
 
 
 
 
 
 
 
 
 
 
 
 //================================================================
 
 
 if(isIncomplete == true){
 if(nmeaString != nmeaForString){
 
 
 if nmeaForString.contains("\r\n"){
 
 if(!auxString.isEmpty){
 
 nmeaString.append(auxString)
 hasStringNMEA = true
 isIncomplete = false
 }
 
 
 let lineArray = nmeaForString.split{ $0 == "\n" || $0 == "\r\n" }.map(String.init)
 nmeaString = lineArray[0]
 hasStringNMEA = true
 isIncomplete = false
 auxString = lineArray[1]
 }
 
 }
 
 if(nmeaString.lengthOfBytes(using: .utf8) <= 80){
 isIncomplete = false
 hasStringNMEA = true
 return
 }
 }
 
 print("is incomplete \(isIncomplete) nmeaString: \(nmeaString) ")
 
 if(nmeaForString.contains("$")){
 
 //if not contain terminator is incomplete
 if !nmeaForString.contains("\r\n") || !nmeaForString.contains("\n"){
 isIncomplete = true
 }
 
 let tok =  nmeaForString.countInstances(of: "$")
 //found 1 dollar
 if(tok == 1){
 
 let char = nmeaForString.character(at: 0)
 if char == "$"{
 if nmeaForString.contains("\r\n"){
 //received a sentence nmea with other joined
 let lineArray = nmeaForString.split{ $0 == "\n" || $0 == "\r\n" }.map(String.init)
 nmeaString = lineArray[0]
 hasStringNMEA = true
 if(!lineArray[1].isEmpty){
 auxString = lineArray[1]
 }
 print("have $ in first character   \(nmeaString)")
 return
 }else{
 //received not entired entired nmea setence
 nmeaString = nmeaForString
 hasStringNMEA = false
 return
 }
 }else{
 let lineArray = nmeaForString.split(separator: "$")//.map(String.init)
 isIncomplete = true
 nmeaString = String.init(lineArray[1])
 print("don't have $ in first character   \(nmeaString)")
 return
 }
 }
 
 }
 
 
 //middle part of setence
 if(!nmeaString.isEmpty && nmeaForString != nmeaString ){
 
 nmeaString.append(nmeaForString)
 hasStringNMEA = false
 isIncomplete = true
 }
 
 
 
 
 
 
 if(lineArray.count > 1){
 if(!nmeaString.isEmpty){
 nmeaString.append(lineArray[0])
 }else{
 if(lineArray[1].character(at: 0) == "$"){
 nmeaString = lineArray[1]
 }
 }
 }else{
 if(!nmeaString.isEmpty){
 nmeaString.append(lineArray[0])
 }else{
 nmeaString = lineArray[0]
 }
 }
 */
