import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
  vus: 100,
  duration: '10m',
};
export default function () {
//  http.get('http://127.0.0.1:8080/blogs/v1/blogs');
  http.get('http://127.0.0.1/');
  sleep(1);
}