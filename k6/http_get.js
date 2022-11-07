import http from 'k6/http';
import { sleep } from 'k6';
import { htmlReport } from "https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js";

export function handleSummary(data) {
  return {
    "new2.html": htmlReport(data), // show report in html based format.
    'stdout': textSummary(data, { indent: ' ', enableColors: true }), // Show the text summary to stdout format...
  };
}

export const options = {
  vus: 100,
  duration: '10m',
};
export default function () {
//  http.get('http://127.0.0.1:8080/blogs/v1/blogs');
  http.get('http://127.0.0.1/');
  sleep(1);
}