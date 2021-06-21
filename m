Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B103AEC56
	for <lists+linux-bcache@lfdr.de>; Mon, 21 Jun 2021 17:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhFUP33 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 21 Jun 2021 11:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbhFUP32 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 21 Jun 2021 11:29:28 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B62DC061574
        for <linux-bcache@vger.kernel.org>; Mon, 21 Jun 2021 08:27:14 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id k5so2033032ilv.8
        for <linux-bcache@vger.kernel.org>; Mon, 21 Jun 2021 08:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8MsMwreI693eD5gNSmDYbmS+b6b+rovuZ4aY3kOfDRI=;
        b=ixRTT9jeggvOgk3bUvBPWhoQ3EEOsxOIFnAJg+eff+mAIKbyS6qga50TDSzWSz2vNs
         rbPTh74IMiqLGAlzHzPu8sq816CreKlI5CCCcWoLO/8Mtc0hRjibYt/1XRN4aEsSW9kk
         QAyLmW3waB9jvbyx8My585dSI9td3fWZR5JhxFHLvmnU/80OTEYOAyXWmJV7fEt46SHC
         bFEoi/SH6G49VqNmcgPaAZi41jZsE2BkhTEJ6waCXWELX0JyHiCJUaj3WaWt8QweLWn2
         COLUF/6HpRQTZPwrkGu92RCb1w8S1hB8f8ncJuBDC45KY5NIA4cRhmYNffWbxcNMpKFk
         uKbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8MsMwreI693eD5gNSmDYbmS+b6b+rovuZ4aY3kOfDRI=;
        b=Qih4ANk26ljJEwJhWJRiUZkqqAg33tutzSTpg2v2E4pWExo4QeZ4xW2HDurPqIhTUx
         hSE4v7BuMwjh4B0tmvd89p1T7VFZ1LO+nNXcj5uWNBGuA1eI4fGeXokf8cs58ffDI/HT
         27wLCwLTj+3riExR6Oa+A1BRmcqYw7cyGMqaTsEOyArraDawdPIMEc3TSW2TW5LN79p0
         FaYa7yMXCKhUNiylJPXY42EkHfrDoBClutQL+6NrNMa4JoQM7f6vHg+BqBn8uZU19Tlr
         IjTrRIF2yFV5nJjB+k0iK3bd0BKzGQz2FSxfShQxjUy/aLD55aBygSe+C7TnNOeI9Llk
         nZDg==
X-Gm-Message-State: AOAM532VDyub3R5grDRvW+n14qC3qkqNIP4pXU1M7JYcXNd7oQoefqYZ
        6Jg4Cw/sUE+vnaY8i9JGaHZ4zA==
X-Google-Smtp-Source: ABdhPJyYaCjd+F9CzL3X6EKhyC0mllZtYHV6vfXR7MOD2yr1QQEKY7GuliQsJwBgHV6PpYFWsWfS/Q==
X-Received: by 2002:a05:6e02:972:: with SMTP id q18mr587023ilt.88.1624289233601;
        Mon, 21 Jun 2021 08:27:13 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 14sm6355650ilx.61.2021.06.21.08.27.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 08:27:13 -0700 (PDT)
Subject: Re: [PATCH 00/14] bcache patches for Linux v5.14
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20210615054921.101421-1-colyli@suse.de>
 <cb427b5f-8e55-bed2-1e3d-7382a092d4a0@kernel.dk>
 <02e126b9-f4a8-8034-8c78-d06a3dc41acf@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c05dd81e-0222-62c9-8e52-aee02fa9abb9@kernel.dk>
Date:   Mon, 21 Jun 2021 09:27:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <02e126b9-f4a8-8034-8c78-d06a3dc41acf@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/21/21 9:25 AM, Coly Li wrote:
> On 6/21/21 11:14 PM, Jens Axboe wrote:
>> On 6/14/21 11:49 PM, Coly Li wrote:
>>> Hi Jens,
>>>
>>> Here are the bcache patches for Linux v5.14.
>>>
>>> The patches from Chao Yu and Ding Senjie are useful code cleanup. The
>>> rested patches for the NVDIMM support to bcache journaling.
>>>
>>> For the series to support NVDIMM to bache journaling, all reported
>>> issue since last merge window are all fixed. And no more issue detected
>>> during our testing or by the kernel test robot. If there is any issue
>>> reported during they stay in linux-next, I, Jianpang and Qiaowei will
>>> response and fix immediately.
>>>
>>> Please take them for Linux v5.14.
>> I'd really like the user api bits to have some wider review. Maybe
>> I'm missing something, but there's a lot of weird stuff in the uapi
>> header that includes things like pointers etc.
>>
> 
> Hi Jens,
> 
> As I explained 2 merge windows before, we use nvdimm as non-volatiled
> memory, that is, the
> memory objects are stored on nvdimm as memory object which are
> non-volatiled. This is why
> you see the pointers in the data structure, e.g. the list is stored on
> NVDIMM area, and the code
> goes through the list directly on the NVDIMM, we don't load them into
> memory.
> 
> This is not block device interface.

Right, and I'm not oblivious to those emails. What I'm saying is that
we need more review of that, so far it seems to stand unreviewed.

> I try to ask Dan Williams, Jan Kara, Christoph Hellwig and Hannes
> Reineicke to help to review,
> hope there are some experts may help to take a look.

That'd be great.

-- 
Jens Axboe

