import Foundation
import MarketKit
import UniswapKit

class SwapViewItemHelper {
    func sortedPrices(executionPrice: Decimal?, invertedPrice: Decimal?, tokenIn: MarketKit.Token?, tokenOut: MarketKit.Token?) -> (String, String)? {
        guard let price = executionPrice, let inverted = invertedPrice, let tokenOut, let tokenIn else {
            return nil
        }

        let needToInvert = inverted > price
        let prices = needToInvert ? (inverted, price) : (price, inverted)
        let baseCoins = needToInvert ? (tokenOut, tokenIn) : (tokenIn, tokenOut)
        let quoteCoins = needToInvert ? (tokenIn, tokenOut) : (tokenOut, tokenIn)

        let first = PriceCoinValue(baseCoin: baseCoins.0.coin, quoteAppValue: AppValue(token: quoteCoins.0, value: prices.0))
        let second = PriceCoinValue(baseCoin: baseCoins.1.coin, quoteAppValue: AppValue(token: quoteCoins.1, value: prices.1))

        return (first.formattedFull, second.formattedFull)
    }

    func priceImpactViewItem(priceImpact: Decimal?, impactLevel: UniswapTradeService.PriceImpactLevel?, minLevel: UniswapTradeService.PriceImpactLevel = .normal) -> UniswapModule.PriceImpactViewItem? {
        guard var priceImpact, let impactLevel, impactLevel.rawValue >= minLevel.rawValue else {
            return nil
        }
        priceImpact.negate()
        return UniswapModule.PriceImpactViewItem(
            value: priceImpact.description + "%",
            level: impactLevel
        )
    }

    func slippage(_ slippage: Decimal) -> String? {
        slippage == TradeOptions.defaultSlippage ? nil : "\(slippage)%"
    }

    func deadline(_ deadline: TimeInterval) -> String? {
        let ttl = Decimal(floatLiteral: floor(deadline / 60))
        return deadline == TradeOptions.defaultTtl ? nil : "swap.advanced_settings.deadline_minute".localized(ttl.description)
    }
}

extension SwapViewItemHelper {
    struct PriceCoinValue {
        let baseCoin: Coin
        let quoteAppValue: AppValue

        var formattedFull: String {
            quoteAppValue.formattedFull().map { "1 " + [baseCoin.code, $0].joined(separator: " = ") } ?? ""
        }
    }
}
