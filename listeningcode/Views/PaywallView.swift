import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(SubscriptionManager.self) private var subscriptionManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "headphones.circle.fill")
                            .font(.system(size: 64))
                            .foregroundStyle(Color.accentColor)

                        Text("Unlock All Problems")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Get access to all 150 problems across 18 categories. Master algorithms by listening.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 20)

                    // Features
                    VStack(alignment: .leading, spacing: 12) {
                        FeatureRow(icon: "checkmark.circle.fill", text: "All 18 algorithm categories")
                        FeatureRow(icon: "checkmark.circle.fill", text: "150+ interview dialogue lessons")
                        FeatureRow(icon: "checkmark.circle.fill", text: "Step-by-step visual diagrams")
                        FeatureRow(icon: "checkmark.circle.fill", text: "Prerequisite glossary & phrases")
                    }
                    .padding(.horizontal, 24)

                    // Product buttons
                    VStack(spacing: 12) {
                        ForEach(subscriptionManager.products) { product in
                            Button {
                                Task { await subscriptionManager.purchase(product) }
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(product.displayName)
                                            .font(.headline)
                                        Text(product.description)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Text(product.displayPrice)
                                        .font(.headline)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.accentColor.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .buttonStyle(.plain)
                        }

                        if subscriptionManager.products.isEmpty {
                            Text("Loading subscription options...")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.horizontal, 24)

                    if let error = subscriptionManager.purchaseError {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .padding(.horizontal)
                    }

                    // Restore
                    Button {
                        Task { await subscriptionManager.restorePurchases() }
                    } label: {
                        Text("Restore Purchases")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    // Legal links
                    HStack(spacing: 16) {
                        Link("Terms of Use", destination: URL(string: "https://appuppu.github.io/ListeningCodeDocs/terms-of-use.html")!)
                        Link("Privacy Policy", destination: URL(string: "https://appuppu.github.io/ListeningCodeDocs/privacy-policy.html")!)
                    }
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Premium")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .onChange(of: subscriptionManager.isSubscribed) { _, subscribed in
                if subscribed { dismiss() }
            }
        }
    }
}

private struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.green)
            Text(text)
                .font(.subheadline)
        }
    }
}
