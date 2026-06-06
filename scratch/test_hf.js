import "../settings.js";
import { InferenceClient } from "@huggingface/inference";
import { Blob } from "buffer";
import fs from "fs";

// Minimal 1x1 transparent PNG
const dummyPng = Buffer.from(
  "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=",
  "base64"
);

async function test() {
  const hfToken = process.env.HF_TOKEN || global.qwen.hfToken;
  console.log("Using token:", hfToken.substring(0, 15) + "...");
  const client = new InferenceClient(hfToken);
  
  try {
    const inputBlob = new Blob([dummyPng], { type: "image/png" });
    console.log("Input Blob size:", inputBlob.size);
    
    const imageBlob = await client.imageToImage({
      provider: "fal-ai",
      model: "ScottzillaSystems/qwen-image-edit-plus-nsfw-lora",
      inputs: inputBlob,
      parameters: {
        prompt: "Turn it into a tiger.",
      },
    });
    
    console.log("Success! Response is Blob:", imageBlob instanceof Blob);
    console.log("Response type:", imageBlob.type);
    console.log("Response size:", imageBlob.size);
  } catch (err) {
    console.error("Failed with error:");
    console.error(err);
  }
}

test();
