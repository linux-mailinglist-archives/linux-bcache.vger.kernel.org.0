Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA3CE2F915
	for <lists+linux-bcache@lfdr.de>; Thu, 30 May 2019 11:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfE3JNn (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 30 May 2019 05:13:43 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:37864 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbfE3JNm (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 30 May 2019 05:13:42 -0400
Received: by mail-pg1-f171.google.com with SMTP id 20so1657717pgr.4
        for <linux-bcache@vger.kernel.org>; Thu, 30 May 2019 02:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DrZcjq3zt8x5qgyUolXChrIUBRb3w53/8AvQQzvp3bo=;
        b=nxSNa5J29VtTyd1QOvw7Md0GqMY5654N3ZuKZvLOdqfolly3+uSg/vANKVmOFLuXbC
         BMDKYMnRlVgqeb1VpyDjFdyZnGC/vXAmrsOmopXQN+0I2Au9uAJIW/TBh/jU4wfGhIux
         Kvaku0WoiN3JhdzKjqU3+/2vzY/Y1oDSdoZU+zy6KpwvgRTlY9sxrlm66XxXjfTenHc4
         iG1gAH7d1pOj7mdGckfDhqBt4ixJ/l2ECcb8O1eenQRTRYCe5dKJijV5j0wmmkzrHZBf
         y6ZYV3Cjg3gSCvt0BDkA0bqCEuExUSkEMroF/SGnQYaqkvIReVn6LoOUDvZ3AAHnel6m
         ApZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DrZcjq3zt8x5qgyUolXChrIUBRb3w53/8AvQQzvp3bo=;
        b=Prpul/pa5h8hzENQ2u3XxaKGPUtT++TaW4LzT03zQlyH0mvWsKGUsQ0+94Whipd0QC
         SxuaJvIVUvNvCx+RAsijt5/nIXzBnc3AN+Vc1uEZBPrPVxJD9W54X8kgjlxVxlVvd4Gc
         kDMLJ/WKiZZvLr3JwA2cmAhVXmoKmcQhn2nnfJDA1GEkSXBYfJ4MMYLtowDy2VF/YAP/
         AP37COjNQjfyUlGD7fAsMrcQdO4RkalfhyEIYhh3/gWAKoizKfkl988u3VsXUgnxJpWY
         SWkDk7+PxZZT7qCI+IhwyNWvB8polbcPT+29Ta40RwXRNy/AzZnjovNaxZJCD+NcPKuU
         v3Tw==
X-Gm-Message-State: APjAAAW/9AKqPneHiqCCplNTm6575QRUt+TTxhjIIWzJdOUupcrmOb7t
        91HZaUD1BDinaTOAkZrkUgEXkOcf
X-Google-Smtp-Source: APXvYqxDiRynjQCx/5iYjmWMcGq/u3kU1eCCM8lqFdBusKA0KpTEgpxDaMgyFxl974SN7Na7OV3/ew==
X-Received: by 2002:a63:f410:: with SMTP id g16mr2737273pgi.428.1559207622038;
        Thu, 30 May 2019 02:13:42 -0700 (PDT)
Received: from [0.0.0.0] ([47.244.169.0])
        by smtp.gmail.com with ESMTPSA id y13sm4177033pfb.143.2019.05.30.02.13.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 02:13:41 -0700 (PDT)
Subject: Re: How many memory and ssd space are consumed by metadata of 2T
 caching ssd
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
References: <3c0ef10d-41b9-7c9e-72e5-5272cf6db241@gmail.com>
 <4bff739f-fad7-3b97-e291-460621def079@suse.de>
From:   Jianchao Wang <jianchao.wan9@gmail.com>
Message-ID: <7c524163-05ce-3993-1603-ac8d818924f1@gmail.com>
Date:   Thu, 30 May 2019 17:13:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:67.0) Gecko/20100101
 Thunderbird/67.0
MIME-Version: 1.0
In-Reply-To: <4bff739f-fad7-3b97-e291-460621def079@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly

Thanks so much for your response.

On 2019/5/30 17:03, Coly Li wrote:
> On 2019/5/30 11:22 上午, Jianchao Wang wrote:
>> Dear guys
>>
>> We have an about 200T disk array and want to use a 2T ssd to cache it.
>> How many memory and ssd space are consumed by the bcache when the caching device
>> is nearly used up ?
> 
> Hi Jianchao,
> 
> It heavily depends on your workload for the SSD and memory consuming. It
> is better to test with your workload and get a number.
> 
> For a full random I/O on the 200T disk array, bcache may occupy around
> 75% free space of the SSD, and as many as memory it can require from system.
> 

I mean the only the metadata of bcache, namely the map btree, log, etc.

Thanks
Jianchao
