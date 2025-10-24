//
//  CustomLabel.swift
//  Toyusai2025
//
//  Created by ichinose-PC on 2025/10/23.

import UIKit

//Labelの行間、文字間隔、文字の一部色変え
class CustomLabel: UILabel {

    //文字間隔
    @IBInspectable var Spacing: CGFloat = 0 {
        didSet { updateText() }
    }

    //行間
    @IBInspectable var lineHeight: CGFloat = 0 {
        didSet { updateText() }
    }

    //色を変更する文字
    @IBInspectable var ChangeColorText: String = "" {
        didSet { updateText() }
    }

    //変更する色
    @IBInspectable var ChangeColor: UIColor = .systemRed {
        didSet { updateText() }
    }

    override var text: String? {
        didSet { updateText() }
    }

    //初期化のタイミングで呼ばれる
    override func awakeFromNib()
    {
        super.awakeFromNib()
        updateText()
    }

    private func updateText()
    {
        
        guard let text = text, let font = font else { return }
        
        //figmaの値をそのまま持って来れるように計算
        let convertedSpacing = (Spacing / 100.0) * font.pointSize

        //行間を設定するためのスタイル設定（lineHeightの値を使う、Alignmentはそのまま）
        let paragraphStyle = NSMutableParagraphStyle()
        
        if lineHeight > 0 {
            paragraphStyle.minimumLineHeight = lineHeight
            paragraphStyle.maximumLineHeight = lineHeight
        }
        paragraphStyle.alignment = self.textAlignment
        
        //文字間隔、行間、ラベルの色決定
        let attributed = NSMutableAttributedString(string: text)
        attributed.addAttributes([
            .kern: convertedSpacing,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: self.textColor ?? .label
        ], range: NSRange(location: 0, length: text.count))

        //ChangeCOlorTextを探してChangeColorを適用
        if !ChangeColorText.isEmpty,
           let range = text.range(of: ChangeColorText) {
            let nsRange = NSRange(range, in: text)
            attributed.addAttribute(.foregroundColor, value: ChangeColor, range: nsRange)
        }

        //行の高さを真ん中に合わせる
        if lineHeight > 0 {
            let baselineOffset = (lineHeight - font.lineHeight) / 2
            attributed.addAttribute(.baselineOffset, value: baselineOffset,
                                    range: NSRange(location: 0, length: text.count))
        }

        self.attributedText = attributed
    }
}

//ボタンのテキストの文字間隔設定
class CustomButton: UIButton
{

    @IBInspectable var letterSpacing: CGFloat = 0 {
        didSet { updateSpacing() }
    }

    private func updateSpacing() {
        
        guard let titleLabel = self.titleLabel,
              let text = titleLabel.text,
              let font = titleLabel.font else { return }
        

        let convertedSpacing = (letterSpacing / 100.0) * font.pointSize


        let attributed = NSMutableAttributedString(string: text)
        attributed.addAttribute(.kern, value: convertedSpacing, range: NSRange(location: 0, length: text.count))
        
        attributed.addAttribute(.font, value: font, range: NSRange(location: 0, length: text.count))
        
        attributed.addAttribute(.foregroundColor, value: titleLabel.textColor ?? .label, range: NSRange(location: 0, length: text.count))

        self.setAttributedTitle(attributed, for: .normal)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateSpacing()
    }
}

//UIViewの枠線の太さ、色
class CustomView: UIView
{

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateView()
    }

    private func updateView() {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
    }
}
