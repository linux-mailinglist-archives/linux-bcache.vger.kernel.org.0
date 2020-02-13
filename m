Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F37C15C536
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Feb 2020 16:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbgBMPyM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 13 Feb 2020 10:54:12 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:33820 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728881AbgBMPyL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 13 Feb 2020 10:54:11 -0500
Received: by mail-io1-f67.google.com with SMTP id z193so7035446iof.1
        for <linux-bcache@vger.kernel.org>; Thu, 13 Feb 2020 07:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eIvReTS3Qjoh0tXO0AZKe1IM/rIuvGtF5twfce7QiCo=;
        b=yfTDxgF5SWS1YF/UN8zpFCafDUZ34uo7IijCnGOq7x+ywJ6GYoR0yEgM9N0bBZh779
         6vCbOxS9Rcaj64jVYUhxsx+DJc0rNF/Ux7L+QxyNe9tD8OpRzknH2xFIaxzBUjoyRBOc
         Lsj0JMiDGvIFJ+W5IOr0cuv2kc8oizSmIOorW8Hsnmr/4NtdvB6Sz0oUIoMRzpM+5ELG
         Gox5JRXyCYcdhJX/tkLK3JSW21B0DVlRbbgZv0250D7zNWzVjkJmhjeyYsxnj2dkWYYB
         19qQOa7wlTyJ9REuObU1HR6Bt0hEDlJhhKF9+ogoXAoj/WhQZ2vVX22ifNWgBTlkuKLS
         pLCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eIvReTS3Qjoh0tXO0AZKe1IM/rIuvGtF5twfce7QiCo=;
        b=HUeIBcddtmT4ZymaCMR3LVNedPTWPQKJStEwffgo/lkkw9kI3M09NvtT/NodMWNpxS
         hKWZwBDhsVO4hHPqaF7nNAipRJ2MjiVJmV/V/PC4y1q5DXQRQh68kzK7JpXJHFMbh7MV
         Iu7dE2RTi87/Aq/rv9b1LgaGzxM8qh8v6TTyUiNHxAvhH43hnm+YZFpbeUisX0WC7Jw1
         WrsP7tSMmzjml9yko2Sm0sDFSMM0dIUcPZJY+LHSVhSvi1CTonaca+CqJscOdPbeMsXG
         +FNRQlY6pt4lrIR7dYS/fQADQyPqCQ4yon/vDwlAgkDH0LNM50l85YPjTH7u3LAv1mIx
         NlAw==
X-Gm-Message-State: APjAAAWzMAB2AI9ak1m0T315a3ORPTGJ3cQ2IsdtvLVrHxNaPXamGkmZ
        BHroQD5yzZuOVZf3Av00s4dAAqyMH2s=
X-Google-Smtp-Source: APXvYqwGZfN4lk7ulX6F2FpaVGaM0d9VzIWAe4IBRaj+EZElMpyCZOm5zkJxHU69QZ5e4rG89Wqelg==
X-Received: by 2002:a5d:878c:: with SMTP id f12mr22741292ion.164.1581609250827;
        Thu, 13 Feb 2020 07:54:10 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f16sm987752ilq.16.2020.02.13.07.54.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2020 07:54:10 -0800 (PST)
Subject: Re: [PATCH 0/3] bcache patches for Linux v5.6-rc2
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20200213141207.77219-1-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d724bf95-31f5-ae94-9774-d978c00ca544@kernel.dk>
Date:   Thu, 13 Feb 2020 08:54:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200213141207.77219-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2/13/20 7:12 AM, Coly Li wrote:
> Hi Jens,
> 
> Here are 3 minor fixes Linux v5.6-rc2. The first 2 patches fix
> kthread creating failure during bcache cache set starts up. The
> last patch is a code clean up.
> 
> Please take them. Thanks in advance.

Applied, thanks.

-- 
Jens Axboe

