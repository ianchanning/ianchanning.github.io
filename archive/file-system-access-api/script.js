import { get, set } from "https://unpkg.com/idb-keyval@5.0.2/dist/esm/index.js";

const pre1 = document.querySelector("pre.file");
const pre2 = document.querySelector("pre.directory");
const button1 = document.querySelector("button.file");
const button2 = document.querySelector("button.directory");

button1.addEventListener("click", async () => {
  try {
    const fileHandleOrUndefined = await get("file");
    if (fileHandleOrUndefined) {
      pre1.textContent = `Retrieved file handle "${fileHandleOrUndefined.name}" from IndexedDB.`;
      return;
    }
    const [fileHandle] = await window.showOpenFilePicker();
    await set("file", fileHandle);
    pre1.textContent = `Stored file handle for "${fileHandle.name}" in IndexedDB.`;
  } catch (error) {
    alert(error.name, error.message);
  }
});

button2.addEventListener("click", async () => {
  try {
    const directoryHandleOrUndefined = await get("directory");
    if (directoryHandleOrUndefined) {
      pre2.textContent = `Retrieved directory handle "${directoryHandleOrUndefined.name}" from IndexedDB.`;
      for await (const [key, value] of directoryHandleOrUndefined.entries()) {
        console.log({ key, value });
      }
      return;
    }
    const directoryHandle = await window.showDirectoryPicker();
    await set("directory", directoryHandle);
    pre2.textContent = `Stored directory handle for "${directoryHandle.name}" in IndexedDB.`;
  } catch (error) {
    alert(error.name, error.message);
  }
});
