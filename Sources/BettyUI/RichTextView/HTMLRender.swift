//
//  HTMLRender.swift
//
//
//  Created by Brian Kim on 30/12/2023.
//

import SwiftUI
import SwiftSoup

enum HiggsError: Error {
    case badString
}

public struct HTMLRender {
    let baseFontSize: CGFloat = 15.0
    let style: ThemeStyleConfiguration
    
    public init(with style: ThemeStyleConfiguration) {
        self.style = style
    }
    
        public mutating func attributedString(from document: Document) -> NSAttributedString {
            guard let body: Element = document.body() else {
                return NSAttributedString.empty
            }
    
            let result = NSMutableAttributedString()
    
            let children = body.children()
    
            for element in children {
                result.append(defaultVisit(element))
                result.append(.singleNewline(withFontSize: baseFontSize))
            }
    
            return result
        }
    
        public mutating func defaultVisit(_ element: Element, iteration: Int = 0) -> NSAttributedString {
            switch element.tag().getName() {
            case "h1":
                return visitHeading(element, level: 1)
            case "h2":
                return visitHeading(element, level: 2)
            case "h3":
                return visitHeading(element, level: 3)
            case "h4":
                return visitHeading(element, level: 4)
            case "h5":
                return visitHeading(element, level: 5)
            case "h6":
                return visitHeading(element, level: 6)
            case "blockquote":
                return visitBlockQuote(element, listDepth: iteration)
            case "pre":
                return visitCodeBlock(element)
            case "ul":
                return visitUnorderedList(element, listDepth: iteration)
            case "ol":
                return visitOrderedList(element, listDepth: iteration)
            case "li":
                return visitListItem(element)
            case "p":
                return visitParagraph(element, listDepth: iteration)
            case "span":
                return visitParagraph(element)
            case "em":
                return inlineRender(element, to: .emphasis)
            case "strong":
                return inlineRender(element, to: .strong)
            case "del":
                return inlineRender(element, to: .del)
            case "a":
                return visitLink(element)
            case "code":
                return visitInlineCode(element)
            case "img":
                return visitImage(element)
            case "table":
                return visitTable(element)
            default: break
            }
            return NSAttributedString(string: "")
        }
    
        public mutating func visit(_ text: String) -> NSMutableAttributedString {
            let result = NSMutableAttributedString(string: text)
            result.addAttributes([.font : UXFont.systemFont(ofSize: baseFontSize, weight: .regular)])
            return result
        }
    
        public mutating func visitHeading(_ heading: Element, level: Int) -> NSAttributedString {
            guard let text = try? heading.text() else {
                return NSAttributedString.empty
            }
    
            let header = NSMutableAttributedString()
            header.append(visit(text))
            header.applyHeading(color: style.fgColor, withLevel: level)
            header.append(.singleNewline(withFontSize: baseFontSize))
    
            return header
        }
    
        public mutating func visitParagraph(_ paragraph: Element, listDepth: Int = 0) -> NSAttributedString {
            let result = NSMutableAttributedString()
    
            for node in paragraph.getChildNodes() {
                if listDepth != 0 { print(listDepth, node.description) }
                if let element = node as? Element {
                    result.append(defaultVisit(element))
    
                } else {
                    result.append(visit(node.description))
                }
            }
    
            result.applyParagraph(color: style.fgLightColor)
            result.append(.singleNewline(withFontSize: baseFontSize))
            return result
        }
    
        mutating public func visitLink(_ link: Element) -> NSAttributedString {
            let text = link.ownText()
    
            guard let destination = try? link.attr("href") else {
                return  NSAttributedString.empty
            }
    
            let result = visit(text)
    
            let url = URL(string: destination)
    
            for child in link.children() {
                result.append(NSAttributedString(string: " "))
                result.append(defaultVisit(child))
            }
    
            result.applyLink(color: style.fgColor, withURL: url)
    
            return result
        }
    
        mutating public func visitInlineCode(_ inlineCode: Element) -> NSAttributedString {
            guard let text = try? inlineCode.html() else {
                return NSAttributedString.empty
            }
            return NSAttributedString(string: text, attributes: [.font: UXFont.monospacedSystemFont(ofSize: baseFontSize - 1.0, weight: .regular), .foregroundColor: style.fgFadedColor])
        }
    
        mutating public func visitUnorderedList(_ unorderedList: Element, listDepth: Int = 0) -> NSAttributedString {
            let result = NSMutableAttributedString()
    
            let font = UXFont.systemFont(ofSize: baseFontSize, weight: .regular)
    
            for listItem in unorderedList.children() {
                let bulletWidth = ceil(NSAttributedString(string: "•", attributes: [.font: font]).size().width)
    
                let listItemAttributes = listItemAttributes(width: bulletWidth, listDepth: listDepth)
    
                let listItemAttributedString = appendListChildren(listItem, listDepth: listDepth)
    
                listItemAttributedString.insert(NSAttributedString(string: "\t•\t", attributes: listItemAttributes), at: 0)
    
                result.append(listItemAttributedString)
            }
    
            return result
        }
    
        mutating public func visitOrderedList(_ orderedList: Element, listDepth: Int = 0) -> NSAttributedString {
            let result = NSMutableAttributedString()
            let numeralFont = UXFont.monospacedDigitSystemFont(ofSize: baseFontSize, weight: .regular)
    
            for (index, listItem) in orderedList.children().enumerated() {
                let highestNumberInList = orderedList.children().count
                let numeralColumnWidth = ceil(NSAttributedString(string: "\(highestNumberInList).", attributes: [.font: numeralFont]).size().width)
    
                let listItemAttributes = listItemAttributes(width: numeralColumnWidth, listDepth: listDepth)
    
                let listItemAttributedString = appendListChildren(listItem, listDepth: listDepth)
    
                // Same as the normal list attributes, but for prettiness in formatting we want to use the cool monospaced numeral font
                var numberAttributes = listItemAttributes
                numberAttributes[.font] = numeralFont
                numberAttributes[.foregroundColor] = style.fgFadedColor
    
                let numberAttributedString = NSAttributedString(string: "\t\(index + 1).\t", attributes: numberAttributes)
    
                listItemAttributedString.insert(numberAttributedString, at: 0)
    
                result.append(listItemAttributedString)
            }
    
            return result
        }
    
        mutating public func visitListItem(_ listItem: Element) -> NSAttributedString {
            let result = NSMutableAttributedString()
    
            for child in listItem.children() {
                result.append(defaultVisit(child))
            }
    
            if listItem.nextSibling() != nil {
                result.append(.singleNewline(withFontSize: baseFontSize))
            }
    
            return result
        }
    
        public mutating func visitCodeBlock(_ codeBlock: Element) -> NSAttributedString {
            guard let text = try? codeBlock.text() else {
                return  NSAttributedString.empty
            }
    
            let result = NSMutableAttributedString(string: text, attributes: [.font: UXFont.monospacedSystemFont(ofSize: baseFontSize - 1.0, weight: .regular), .foregroundColor: style.fgFadedColor])
    
            if codeBlock.nextSibling() != nil {
                result.append(.singleNewline(withFontSize: baseFontSize))
            }
    
            return result
        }
    
        public mutating func visitImage(_ imageBlock: Element) -> NSAttributedString {
            guard let imageUrl = try? imageBlock.attr("src"),
                  let url = URL(string: imageUrl) else {
                return NSAttributedString.empty
            }
    
            guard let html = try? imageBlock.outerHtml() else { return NSAttributedString.empty }
            let parsedCommentHTML = html.replacingOccurrences(of: "<img>\n", with: "<img src=\"\(imageUrl)\" />")
            let blockQuoteCSS = "\nblockquote > p {color:#808080; display: inline;} \n blockquote { background: #f9f9f9;}"
            let pCSS = "p {margin-bottom: 0px;}"
            let cssStyle = "\(blockQuoteCSS)\n\(pCSS)\n"
    
            let data = "<html><head><style>\(cssStyle)</style></head><span style=\"font-family: HelveticaNeue-Thin; font-size: 17\">\(parsedCommentHTML)</span></html>".data(using: .utf16)
    
            guard let data,
                  let attributedString = try? NSAttributedString(data: data, options: [.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil) else { return NSAttributedString.empty }
    
            return attributedString
    
    
    //        let attachment = NSTextAttachment()
    //        let image = NSImage(data: imageData)
    //        attachment.image = image
    //
    //        let result = NSAttributedString(attachment: attachment)
    //
    //        return result
        }
    
        public mutating func visitBlockQuote(_ blockQuote: Element, listDepth: Int = 0) -> NSAttributedString {
            let result = NSMutableAttributedString()
    
            if listDepth == 0 && !blockQuote.ownText().isEmpty {
                let paragraph = Element(Tag.init("p"), "")
                do {
                    let item = try paragraph.text(blockQuote.ownText())
                    try blockQuote.appendChild(item)
                } catch {
                    return NSAttributedString.empty
                }
            }
    
            for blockQuoteItem in blockQuote.children() {
                var quoteAttributes: [NSAttributedString.Key: Any] = [:]
    
                let quoteParagraphStyle = NSMutableParagraphStyle()
    
                let baseLeftMargin: CGFloat = 15.0
                let leftMarginOffset = baseLeftMargin + (20.0 * CGFloat(listDepth))
    
    //            quoteParagraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: leftMarginOffset)]
    //            quoteParagraphStyle.paragraphSpacingBefore = baseFontSize
                quoteParagraphStyle.firstLineHeadIndent = leftMarginOffset
                quoteParagraphStyle.headIndent = leftMarginOffset
    
                quoteAttributes[.paragraphStyle] = quoteParagraphStyle
                quoteAttributes[.font] = UXFont.systemFont(ofSize: baseFontSize, weight: .regular)
                quoteAttributes[.listDepth] = listDepth
    
                let quoteAttributedString = visit(blockQuoteItem.ownText())
                quoteAttributedString.insert(NSAttributedString(string: "\t", attributes: quoteAttributes), at: 0)
                quoteAttributedString.append(.singleNewline(withFontSize: baseFontSize))
    
                quoteAttributedString.addAttribute(.foregroundColor, value: style.foregroundFaded)
    
                for blockQuoteChild in blockQuoteItem.children() {
                    let attributedString = NSMutableAttributedString(attributedString: defaultVisit(blockQuoteChild, iteration: listDepth + 1))
                    let quoteParagraphStyle = NSMutableParagraphStyle()
    
                    let baseLeftMargin: CGFloat = 15.0
                    let leftMarginOffset = baseLeftMargin + (20.0 * CGFloat(listDepth + 1))
    
        //            quoteParagraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: leftMarginOffset)]
        //            quoteParagraphStyle.paragraphSpacingBefore = baseFontSize
                    quoteParagraphStyle.firstLineHeadIndent = leftMarginOffset
                    quoteParagraphStyle.headIndent = leftMarginOffset
    
                    attributedString.addAttributes([.paragraphStyle : quoteParagraphStyle])
    
                    quoteAttributedString.append(attributedString)
                }
    
                result.append(quoteAttributedString)
            }
    
    //        if blockQuote.nextSibling() != nil {
    //            result.append(.singleNewline(withFontSize: baseFontSize))
    //        }
    
            return result
        }
    
        public mutating func visitTable(_ table: Element) -> NSAttributedString {
            let result = NSMutableAttributedString()
            let textTable = NSTextTable()
    
            if let tableHeaders = try? table.select("thead > tr > th") {
                for (index, tableHeader) in tableHeaders.enumerated() {
                    result.append(createTableCell(string: tableHeader.ownText(), textTable: textTable, row: 0, column: index, width: 25, isHeader: true))
                }
                textTable.numberOfColumns = tableHeaders.count
            }
    
            if let tableBodyRows = try? table.select("tbody > tr") {
                for (rowIndex, tableBodyRow) in tableBodyRows.enumerated() {
                    for (colIndex, column) in tableBodyRow.children().enumerated() {
                        result.append(createTableCell(string: column.ownText(), textTable: textTable, row: rowIndex + 1, column: colIndex, width: 25))
                        print(column.ownText(), rowIndex, colIndex)
                    }
                }
            }
    
            return result
        }
    
        func createTextTableBlock(textTable: NSTextTable, row: Int, column: Int, columnSpan: Int = 1, width: CGFloat, isHeader: Bool = false, isNested: Bool = false) -> NSTextTableBlock {
            let block = NSTextTableBlock(table: textTable, startingRow: row, rowSpan: 1, startingColumn: column, columnSpan: columnSpan)
            block.backgroundColor = .white.withAlphaComponent(0.1)
            block.setBorderColor(.gray)
            block.setWidth(1.0, type: NSTextBlock.ValueType.absoluteValueType, for: NSTextBlock.Layer.border)
            block.setWidth(4.0, type: NSTextBlock.ValueType.absoluteValueType, for: NSTextBlock.Layer.padding)
    
            block.setContentWidth(width, type: .percentageValueType)
            return block
        }
    
        func createTableCell(string: String, textTable: NSTextTable, row: Int, column: Int, columnSpan:Int=1, width: CGFloat, isHeader: Bool = false, isNested: Bool = false, parentBlocks: [NSTextTableBlock] = []) -> NSAttributedString {
            let block = createTextTableBlock(textTable: textTable, row: row, column: column, columnSpan: columnSpan, width: width, isHeader: isHeader, isNested: isNested)
    
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = isNested ? .center : .left
            paragraphStyle.textBlocks = parentBlocks + [block]
    
    
            return NSAttributedString(string: string + "\n", attributes: [
                .font: UXFont.systemFont(ofSize: baseFontSize, weight: isHeader ? .bold : .regular),
                .foregroundColor: style.fgLightColor,
                .paragraphStyle: paragraphStyle]
            )
        }
    
        private mutating func listItemAttributes(width: CGFloat, listDepth: Int) -> [NSAttributedString.Key: Any] {
            let baseLeftMargin: CGFloat = 15.0
            let leftMarginOffset = baseLeftMargin + (20.0 * CGFloat(listDepth))
            let spacingFromIndex: CGFloat = 8.0
    
            let listItemParagraphStyle = NSMutableParagraphStyle()
    
            let firstTabLocation = leftMarginOffset + width
            let secondTabLocation = firstTabLocation + spacingFromIndex
    
            listItemParagraphStyle.tabStops = [
                NSTextTab(textAlignment: .right, location: firstTabLocation),
                NSTextTab(textAlignment: .left, location: secondTabLocation)
            ]
    
            listItemParagraphStyle.headIndent = secondTabLocation
    
            /// List Item Attributes
    
            let font = UXFont.systemFont(ofSize: baseFontSize, weight: .regular)
            var listItemAttributes: [NSAttributedString.Key: Any] = [:]
            listItemAttributes[.paragraphStyle] = listItemParagraphStyle
            listItemAttributes[.font] = font
            listItemAttributes[.listDepth] = listDepth
            return listItemAttributes
        }
    
        private mutating func appendListChildren(_ list: Element, listDepth: Int) -> NSMutableAttributedString {
            let listItemAttributedString = visit(list.ownText())
            listItemAttributedString.append(.singleNewline(withFontSize: baseFontSize))
    
            for listItemChild in list.children() {
                listItemAttributedString.append(defaultVisit(listItemChild, iteration: listDepth + 1))
            }
    
            return listItemAttributedString
        }
    
    
        private mutating func inlineRender(_ element: Element, to inlineElement: InlineElements) -> NSAttributedString {
            let text = element.ownText()
            let result = visit(text)
    
            inlineElement.render(result)
    
            for child in element.children() {
                result.append(NSAttributedString(string: " "))
                let childResult = NSMutableAttributedString(attributedString: defaultVisit(child))
                inlineElement.render(childResult)
                result.append(childResult)
            }
            return result
        }
    
        private enum InlineElements {
            case emphasis, strong, del
    
            func render(_ result: NSMutableAttributedString) {
                switch self {
                case .emphasis:
                    result.applyEmphasis()
                case .strong:
                    result.applyStrong()
                case .del:
                    result.applyStrikethrough()
                }
            }
        }
    }
