tailwind.config = {
    darkMode: "class",
    theme: {
        extend: {
            colors: {
                "primary": "#65a30d",
                "primary-container": "#84cc16",
                "on-primary": "#ffffff",
                "on-primary-container": "#f7fee7",
                "secondary": "#ea580c",
                "secondary-container": "#fb923c",

                /* Tông màu nền đã tinh chỉnh hơi phớt xanh hữu cơ nhẹ, làm nổi bật nền card #ffffff */
                "background": "#eef7ee",
                "on-background": "#0f172a",

                "surface": "#ffffff",
                "surface-container-lowest": "#ffffff",
                "surface-container-low": "#f4faf3",
                "surface-container": "#e8f3e7",
                "surface-container-high": "#dbeade",

                "on-surface": "#1e293b",
                "on-surface-variant": "#64748b",
                "outline": "#cbd5e1",
                "outline-variant": "#dbeade",

                "error": "#ef4444",
                "error-container": "#fee2e2",
                "on-error": "#ffffff",
                "on-error-container": "#b91c1c"
            },
            boxShadow: {
                'soft': '0 4px 20px -2px rgba(101, 163, 13, 0.08), 0 2px 6px -1px rgba(0, 0, 0, 0.04)',
                'card': '0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.02)',
                'glow': '0 0 15px rgba(132, 204, 22, 0.4)',
            },
            keyframes: {
                fadeIn: {
                    '0%': { opacity: '0' },
                    '100%': { opacity: '1' },
                },
                slideUp: {
                    '0%': { opacity: '0', transform: 'translateY(20px)' },
                    '100%': { opacity: '1', transform: 'translateY(0)' },
                },
                float: {
                    '0%, 100%': { transform: 'translateY(0)' },
                    '50%': { transform: 'translateY(-8px)' },
                },
                pulseSoft: {
                    '0%, 100%': { opacity: '1' },
                    '50%': { opacity: '0.8' },
                }
            },
            animation: {
                'fade-in': 'fadeIn 0.5s ease-out',
                'slide-up': 'slideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards',
                'float': 'float 3s ease-in-out infinite',
                'pulse-soft': 'pulseSoft 2s cubic-bezier(0.4, 0, 0.6, 1) infinite',
            },
            borderRadius: {
                "DEFAULT": "0.5rem",
                "lg": "0.75rem",
                "xl": "1rem",
                "2xl": "1.25rem",
                "full": "9999px"
            },
            spacing: {
                "base-unit": "8px",
                "margin-mobile": "16px",
                "container-max-width": "1280px",
                "margin-desktop": "48px",
                "gutter": "24px"
            },
            fontFamily: {
                "body-lg": ["Inter", "sans-serif"],
                "display-lg-mobile": ["Plus Jakarta Sans", "sans-serif"],
                "headline-md": ["Plus Jakarta Sans", "sans-serif"],
                "body-md": ["Inter", "sans-serif"],
                "label-bold": ["Inter", "sans-serif"],
                "display-lg": ["Plus Jakarta Sans", "sans-serif"],
                "price-tag": ["Plus Jakarta Sans", "sans-serif"]
            },
            fontSize: {
                "body-lg": ["18px", { "lineHeight": "28px", "fontWeight": "400" }],
                "display-lg-mobile": ["32px", { "lineHeight": "40px", "letterSpacing": "-0.01em", "fontWeight": "800" }],
                "headline-md": ["24px", { "lineHeight": "32px", "fontWeight": "700" }],
                "body-md": ["15px", { "lineHeight": "24px", "fontWeight": "400" }],
                "label-bold": ["14px", { "lineHeight": "20px", "fontWeight": "600" }],
                "display-lg": ["48px", { "lineHeight": "56px", "letterSpacing": "-0.02em", "fontWeight": "800" }],
                "price-tag": ["20px", { "lineHeight": "24px", "fontWeight": "700" }]
            }
        }
    }
};