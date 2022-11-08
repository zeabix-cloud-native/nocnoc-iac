import http from 'k6/http';
import { sleep } from 'k6';

import { htmlReport } from "https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js";
import { textSummary } from "https://jslib.k6.io/k6-summary/0.0.1/index.js";

export const options = {
  vus: 100,
  duration: '10m',
};
export default function () {
  http.get('https://127.0.0.1:8080/blogs/v1/blogs');
//  http.get('https://127.0.0.1');
  sleep(1);
}

export function handleSummary(data) {
  return {
    "result.html": htmlReport(data),
    stdout: textSummary(data, { indent: " ", enableColors: true }),
  };
}