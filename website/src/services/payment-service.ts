import type { CreatePaymentRequest, PaymentIntent, PaymentService } from "@/types/payment";

export class UnconfiguredPaymentService implements PaymentService {
  async createIntent(_request: CreatePaymentRequest): Promise<PaymentIntent> {
    throw new Error("No payment provider is configured. No charge has been created.");
  }
}

export const paymentService = new UnconfiguredPaymentService();
