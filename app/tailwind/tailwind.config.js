/** @type {import('tailwindcss').Config} */
module.exports = {
    content: ["./src/**/*.{html,js}"],
    theme: {
        extend: {
            fontFamily: {
                cocogoose: ['"Cocogoose Pro"', "sans-serif"],
            },
            colors: {
                primary: {
                    50: '#ecf3ff',
                    100: '#dce8ff',
                    200: '#c1d4ff',
                    300: '#9bb7ff',
                    400: '#738eff',
                    500: '#5266ff',
                    600: '#333bf8',
                    700: '#272bdb',
                    800: '#2328b0',
                    900: '#242a8b',
                    950: '#161853',
                },
            },
        }
    },
    plugins: [
        require("@tailwindcss/forms"),
        require("@tailwindcss/aspect-ratio"),
        require("@tailwindcss/typography"),
    ],
}
