const path = require('path');

module.exports = {
    entry: './app/javascript/application.js',
    output: {
        filename: 'application.js',
        path: path.resolve(__dirname, 'public/packs/js'),
    },
    mode: 'production',
    module: {
        rules: [
            {
                test: /\.js$/,
                exclude: /node_modules/,
                use: {
                    loader: 'babel-loader',
                    options: {
                        presets: ['@babel/preset-env'],
                    },
                },
            },
        ],
    },
};
