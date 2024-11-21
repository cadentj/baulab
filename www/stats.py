import pynvml

def get_cuda_memory_usage():
    pynvml.nvmlInit()
    device_count = pynvml.nvmlDeviceGetCount()
    stats = []
    for i in range(device_count):
        handle = pynvml.nvmlDeviceGetHandleByIndex(i)
        memory_info = pynvml.nvmlDeviceGetMemoryInfo(handle)

        stats.append(
            {
                "total": memory_info.total / 1024 ** 2,
                "used": memory_info.used / 1024 ** 2,
                "free": memory_info.free / 1024 ** 2,
            }
        )
    pynvml.nvmlShutdown()

    return stats

def main():
    stats = get_cuda_memory_usage()
    print(stats)


if __name__ == "__main__":
    main()

