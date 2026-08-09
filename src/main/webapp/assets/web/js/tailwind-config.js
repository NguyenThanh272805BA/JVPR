tailwind.config = {
    darkMode: "class",
    theme: {
        extend: {
            colors: {
                "on-tertiary-container": "#7b0080", "on-secondary-container": "#496b5e",
                "on-error": "#ffffff", "primary": "#436900", "on-primary-fixed": "#112000",
                "inverse-on-surface": "#e9f1fe", "inverse-primary": "#95da2a",
                "error-container": "#ffdad6", "on-surface": "#141c25", "tertiary": "#9d28a0",
                "surface-container-lowest": "#ffffff", "tertiary-fixed": "#ffd6f7",
                "surface-container-highest": "#dae3f0", "on-error-container": "#93000a",
                "on-tertiary": "#ffffff", "outline": "#727a64", "surface-dim": "#d2dbe7",
                "secondary-container": "#c5ebda", "on-tertiary-fixed": "#37003a",
                "secondary-fixed": "#c5ebda", "tertiary-fixed-dim": "#ffaaf7",
                "secondary": "#436558", "surface-tint": "#436900", "primary-fixed": "#b0f748",
                "surface-container": "#e6effb", "primary-fixed-dim": "#95da2a",
                "on-secondary-fixed-variant": "#2b4d41", "on-primary-container": "#2f4c00",
                "secondary-fixed-dim": "#aacfbe", "error": "#ba1a1a", "on-secondary": "#ffffff",
                "surface": "#f7f9ff", "on-surface-variant": "#424936",
                "tertiary-container": "#ff82fb", "background": "#f7f9ff",
                "on-primary-fixed-variant": "#314f00", "surface-container-high": "#e0e9f5",
                "surface-variant": "#dae3f0", "surface-container-low": "#edf4ff",
                "surface-bright": "#f7f9ff", "on-secondary-fixed": "#002117",
                "primary-container": "#81c408", "outline-variant": "#c2cab0",
                "on-tertiary-fixed-variant": "#800084", "on-primary": "#ffffff",
                "inverse-surface": "#28313b", "on-background": "#141c25"
            },
            borderRadius: { "DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px" },
            spacing: { "base-unit": "8px", "margin-mobile": "16px", "container-max-width": "1320px", "margin-desktop": "48px", "gutter": "24px" },
            fontFamily: {
                "body-lg": ["Inter", "sans-serif"], "display-lg-mobile": ["Plus Jakarta Sans", "sans-serif"],
                "headline-md": ["Plus Jakarta Sans", "sans-serif"], "body-md": ["Inter", "sans-serif"],
                "label-bold": ["Inter", "sans-serif"], "display-lg": ["Plus Jakarta Sans", "sans-serif"],
                "price-tag": ["Plus Jakarta Sans", "sans-serif"]
            },
            fontSize: {
                "body-lg": ["18px", { "lineHeight": "28px", "fontWeight": "400" }],
                "display-lg-mobile": ["32px", { "lineHeight": "40px", "letterSpacing": "-0.01em", "fontWeight": "800" }],
                "headline-md": ["24px", { "lineHeight": "32px", "fontWeight": "700" }],
                "body-md": ["16px", { "lineHeight": "24px", "fontWeight": "400" }],
                "label-bold": ["14px", { "lineHeight": "20px", "fontWeight": "600" }],
                "display-lg": ["48px", { "lineHeight": "56px", "letterSpacing": "-0.02em", "fontWeight": "800" }],
                "price-tag": ["20px", { "lineHeight": "24px", "fontWeight": "700" }]
            }
        }
    }
};