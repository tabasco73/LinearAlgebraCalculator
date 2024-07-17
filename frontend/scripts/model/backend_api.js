
export async function sendMessage(user_message) {
    const url = "http://127.0.0.1:5010/api/endpoint";
    const headers = {
        "Content-Type": "application/json"
    };
    const data = {
        "user_message": user_message
    };
    try {
        const response = await fetch(url, {
            method: 'POST',
            headers: headers,
            body: JSON.stringify(data)
        });

        console.log("Status Code:", response.status);

        const result = await response.json();
        console.log("Response JSON:", result);

        const answer = result.response;
        console.log("Answer:", answer);
        return answer; // Ensure answer is returned within the try block
    } catch (error) {
        console.error('Error:', error);
        return 'Error: Unable to get response from chatbot';
    }
}