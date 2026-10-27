export type PaymentStatus =
  | "PENDING"
  | "PROCESSING"
  | "PAID"
  | "FAILED"
  | "REFUNDED"
  | "CANCELLED";

export interface CreatePaymentRequest {
  tournamentId: string;
  playerId: string;
  paymentMethod: "BKASH" | "NAGAD" | "SSLCOMMERZ" | "STRIPE";
}

export interface PaymentIntent {
  paymentId: string;
  status: PaymentStatus;
  redirectUrl?: string;
}

export interface PaymentService {
  createIntent(request: CreatePaymentRequest): Promise<PaymentIntent>;
}
