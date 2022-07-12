//
//  SearchResultItemView.swift
//  iOS-DollarCostAveraging
//
//  Created by Marina McPeak on 2022-05-03.
//

import SwiftUI

struct SearchResultItemView: View {
    let result: SearchResult
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading) {
                Text(result.symbol)
                    .font(.custom("AvenirNext-DemiBold", size: 18))
                Text(result.type.appending(" ").appending(result.currency))
                    .foregroundColor(Color(cgColor: UIColor.lightGray.cgColor))
                    .font(.custom("Avenir", size: 12))
            }
            Spacer()
            Text(result.name)
                .font(.custom("Avenir", size: 16))
                .lineLimit(4)
                .frame(maxWidth: 160, alignment: .trailing)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct SearchResultItemView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultItemView(result: SearchResult(symbol: "", name: "", type: "", currency: ""))
    }
}

