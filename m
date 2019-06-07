Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48F4A38AD8
	for <lists+linux-bcache@lfdr.de>; Fri,  7 Jun 2019 15:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbfFGNE2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 7 Jun 2019 09:04:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:51158 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727566AbfFGNE2 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 7 Jun 2019 09:04:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B1E97AFBD;
        Fri,  7 Jun 2019 13:04:26 +0000 (UTC)
Subject: Re: [PATCH 1/1] bcache-tools:Add blkdiscard for cache dev
To:     =?UTF-8?B?6Z+m5paw5Lyf?= <xinweiwei90@gmail.com>
Cc:     linux-bcache@vger.kernel.org
References: <114c3049bf90d8e469e49edb307b27218166bcc8.1559729340.git.xinweiwei90@gmail.com>
 <d0952414-2818-8f13-2362-be18aa511a3e@suse.de>
 <CAPiHUS4KCRMtZd0ju_kARrrB4++EBs8EAw35qhOC2FxeHc=neA@mail.gmail.com>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <1c2fb22a-9f82-3a2d-5a73-02b737b04503@suse.de>
Date:   Fri, 7 Jun 2019 21:04:20 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAPiHUS4KCRMtZd0ju_kARrrB4++EBs8EAw35qhOC2FxeHc=neA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/6/7 2:48 下午, 韦新伟 wrote:
> bcache-tools:Do a entire discard when 'bcache make' for cache devices.
> If discard successfully, it will be prompted, or do nothing.
> 
> Thanks for appreciation.
> 

OK....

I will compose a commit log for you, thanks :-)

Coly Li


> 
> Coly Li <colyli@suse.de> 于2019年6月6日周四 下午7:42写道：
>>
>> On 2019/6/6 10:06 上午, Xinwei Wei wrote:
>>> Signed-off-by: Xinwei Wei <xinweiwei90@gmail.com>
>>> ---
>>
>> The code looks good to me. Could you please to offer a detailed commit log ?
>>
>> Thanks.
>>
>> Coly Li
>>
>>>  make.c | 48 +++++++++++++++++++++++++++++++++++++++++++++++-
>>>  1 file changed, 47 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/make.c b/make.c
>>> index e5e7464..4244866 100644
>>> --- a/make.c
>>> +++ b/make.c
>>> @@ -179,6 +179,48 @@ const char * const cache_replacement_policies[] = {
>>>       NULL
>>>  };
>>>
>>> +int blkdiscard_all(char *path, int fd)
>>> +{
>>> +     printf("%s blkdiscard beginning...", path);
>>> +     fflush(stdout);
>>> +
>>> +     uint64_t end, blksize, secsize, range[2];
>>> +     struct stat sb;
>>> +
>>> +     range[0] = 0;
>>> +     range[1] = ULLONG_MAX;
>>> +
>>> +     if (fstat(fd, &sb) == -1)
>>> +             goto err;
>>> +
>>> +     if (!S_ISBLK(sb.st_mode))
>>> +             goto err;
>>> +
>>> +     if (ioctl(fd, BLKGETSIZE64, &blksize))
>>> +             goto err;
>>> +
>>> +     if (ioctl(fd, BLKSSZGET, &secsize))
>>> +             goto err;
>>> +
>>> +     /* align range to the sector size */
>>> +     range[0] = (range[0] + secsize - 1) & ~(secsize - 1);
>>> +     range[1] &= ~(secsize - 1);
>>> +
>>> +     /* is the range end behind the end of the device ?*/
>>> +     end = range[0] + range[1];
>>> +     if (end < range[0] || end > blksize)
>>> +             range[1] = blksize - range[0];
>>> +
>>> +     if (ioctl(fd, BLKDISCARD, &range))
>>> +             goto err;
>>> +
>>> +     printf("done\n");
>>> +     return 0;
>>> +err:
>>> +     printf("\r                                ");
>>> +     return -1;
>>> +}
>>> +
>>>  static void write_sb(char *dev, unsigned int block_size,
>>>                       unsigned int bucket_size,
>>>                       bool writeback, bool discard, bool wipe_bcache,
>>> @@ -354,6 +396,10 @@ static void write_sb(char *dev, unsigned int block_size,
>>>                      sb.nr_in_set,
>>>                      sb.nr_this_dev,
>>>                      sb.first_bucket);
>>> +
>>> +             /* Attempting to discard cache device
>>> +              */
>>> +             blkdiscard_all(dev, fd);
>>>               putchar('\n');
>>>       }
>>>
>>> @@ -429,7 +475,7 @@ int make_bcache(int argc, char **argv)
>>>       unsigned int i, ncache_devices = 0, nbacking_devices = 0;
>>>       char *cache_devices[argc];
>>>       char *backing_devices[argc];
>>> -     char label[SB_LABEL_SIZE];
>>> +     char label[SB_LABEL_SIZE] = { 0 };
>>>       unsigned int block_size = 0, bucket_size = 1024;
>>>       int writeback = 0, discard = 0, wipe_bcache = 0, force = 0;
>>>       unsigned int cache_replacement_policy = 0;
>>>


-- 

Coly Li
