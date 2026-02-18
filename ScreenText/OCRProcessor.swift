import Vision
import AppKit

struct OCRProcessor {
    static func recognizeText(in image: CGImage) async throws -> String {
        NSLog("ScreenText: Starting OCR on image \(image.width)x\(image.height)")

        return try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    NSLog("ScreenText: OCR error - \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                    return
                }

                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    NSLog("ScreenText: No observations returned")
                    continuation.resume(returning: "")
                    return
                }

                NSLog("ScreenText: Found \(observations.count) text observations")

                // Sort observations top-to-bottom, left-to-right
                let sorted = observations.sorted { a, b in
                    let ay = 1 - a.boundingBox.midY
                    let by = 1 - b.boundingBox.midY
                    if abs(ay - by) < 0.02 {
                        return a.boundingBox.minX < b.boundingBox.minX
                    }
                    return ay < by
                }

                let lines = sorted.compactMap { $0.topCandidates(1).first?.string }
                let text = lines.joined(separator: "\n")

                NSLog("ScreenText: OCR result (\(text.count) chars): \(text.prefix(100))...")
                continuation.resume(returning: text)
            }

            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            request.recognitionLanguages = ["ko-KR", "en-US"]

            let handler = VNImageRequestHandler(cgImage: image, options: [:])

            do {
                try handler.perform([request])
            } catch {
                NSLog("ScreenText: Handler error - \(error.localizedDescription)")
                continuation.resume(throwing: error)
            }
        }
    }
}
