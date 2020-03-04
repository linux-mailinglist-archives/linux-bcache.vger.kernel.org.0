Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E53817982C
	for <lists+linux-bcache@lfdr.de>; Wed,  4 Mar 2020 19:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388327AbgCDSmo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 4 Mar 2020 13:42:44 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:41739 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388203AbgCDSmo (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 4 Mar 2020 13:42:44 -0500
Received: by mail-io1-f66.google.com with SMTP id m25so3536483ioo.8
        for <linux-bcache@vger.kernel.org>; Wed, 04 Mar 2020 10:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aowmqH+jxIIMHfi6cwVjuOMBAQUGZOtVBythXJlq3wg=;
        b=1V8CEMS2GN8MJvUzIknKJZighpn0smIcGnGnvbOS0TIHXyZ56NJcxHzYemcc3pfQke
         IhWQa/jjgQJA0iN+8Pi3PmbvC0xibsjBFGVarOG6kgTFTfLtTiFST6bIFH7dtpdPEiMr
         PXDLO25Kyz34aDn88pu35XYZOSINx5EOUFgM6coZ1+YOaOup55jp1+zqVY3kEZxqNvze
         t+OU1lT3pEb5gk4PpPF+ZkqZAWpI6INeHxbf89go8rQ2DYwVWgd7l4+C+DXMidklJQGj
         NcmU+khDtpifCoXjr2XzIcS+yW3r/CeLCWA0jHPG30hrLQxEF7Ne0KLt8lkity9Bc5KS
         q30A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aowmqH+jxIIMHfi6cwVjuOMBAQUGZOtVBythXJlq3wg=;
        b=BvDfmj99JSw8MNVpp7SWAiaYYre1iiaYM4ppsAdI+NfXWZNzWKN2oAAmFczNph6iDj
         aJpUnFxpG3QK7Le064kaalIRDKUlbdKtQZBhTXHeQ3qIB1T6+nU8AqBF2r3O/2/59B+R
         KsnFTFDDsp139D2+PVLf98ODjE8gXcqrzcJsaRKQ3J4Bx0Vwv328wUl+kiWUPW6aGtXf
         qCEQdpqdfe5o5hEzMjuVvflFV7adgeVudQ9s7LYy+ZSjIGI6fScyqEr922W+ykJjgCIU
         BV750+OU2WjNI+nmo3QXY3V+TYz+8pd+oss8kOI4fL/HOCTZd01aGkqzQYnuB8MGuM2/
         nxDg==
X-Gm-Message-State: ANhLgQ3E58SjQUrgf8KM5fyVhXWeAbBBrum2gcy05iSoJf8B/mEiVMjw
        e2RzOEZVScI0c7fLMhjyyXtIDV/QOO0=
X-Google-Smtp-Source: ADFU+vtNXdELHZMcZy9b77s22L7Z+lfjHm6Swz0+NNeBTzLXUJ1tqb7ebPuKv66GC+EtaS0Ndiyweg==
X-Received: by 2002:a02:6a10:: with SMTP id l16mr3894513jac.77.1583347361774;
        Wed, 04 Mar 2020 10:42:41 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l18sm7105635ild.51.2020.03.04.10.42.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 10:42:41 -0800 (PST)
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
To:     Oleg Nesterov <oleg@redhat.com>, Michal Hocko <mhocko@kernel.org>
Cc:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, hare@suse.de, mkoutny@suse.com
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz> <20200302134919.GB9769@redhat.com>
 <20200303080544.GW4380@dhcp22.suse.cz> <20200303121918.GA27520@redhat.com>
 <20200303160307.GI4380@dhcp22.suse.cz> <20200304113613.GA13170@redhat.com>
 <20200304115330.GB13170@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <239a316b-3c43-019a-bef0-409110284789@kernel.dk>
Date:   Wed, 4 Mar 2020 11:42:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200304115330.GB13170@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/4/20 4:53 AM, Oleg Nesterov wrote:
> On 03/04, Oleg Nesterov wrote:
>>
>> arch/arm/common/bL_switcher.c:bL_switcher_thread(). Why does it do
>> flush_signals() ? signal_pending() must not be possible. It seems that
>> people think that wait_event_interruptible() or even schedule() in
>> TASK_INTERRUPTIBLE state can lead to a pending signal but this is not
>> true. Of course, I could miss allow_signal() in bL_switch_to() paths...
> 
> Jens, could you explain flush_signals() in io_sq_thread() ?

I actually don't think that one is needed - the only one that io_uring
needs, and which is valid, is flushing signals for the io-wq worker as
we use that for cancelation.

In any case, both are kthreads.

-- 
Jens Axboe

