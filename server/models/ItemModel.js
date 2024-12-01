const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const itemSchema = new Schema(
    {
        uid: {
            type: String,
            required: true,
            unique: true,
        },
        images: {
            type: Array, 
            required: true,
            unique: false
        },
        name: {
            type: String,
            required: true,
            unique: true
        },
        description: {
            type: String,
            required: true,
            unique: true
        },
        price: {
            type: Number, 
            required: true,
            unique: false
        },
        inventoryQty: {
            type: Number, 
            required: true, 
            unique: false
        }
    },
    {
        timestamps: true
    }
);

const Item = mongoose.model("Item", itemSchema);

module.exports = Item;