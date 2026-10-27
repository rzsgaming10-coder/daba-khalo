import type { Metadata } from "next";
import { SiteHeader } from "@/components/site-header";
import "./globals.css";

export const metadata: Metadata = {
  title: "Daba Khalo — The Chess Arena",
  description: "Play, compete, and climb the Daba Khalo tournament rankings.",
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="en">
      <body>
        <SiteHeader />
        <main>{children}</main>
        <footer className="site-footer">
          <div className="shell footer-inner">
            <span>© 2026 Daba Khalo</span>
            <span>Play fair. Play bold.</span>
            <a href="mailto:hello@dabakhalo.com">Contact</a>
          </div>
        </footer>
      </body>
    </html>
  );
}
