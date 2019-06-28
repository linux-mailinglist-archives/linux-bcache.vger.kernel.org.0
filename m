Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C52CA59D1E
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Jun 2019 15:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfF1NnA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 28 Jun 2019 09:43:00 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:32942 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfF1NnA (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 28 Jun 2019 09:43:00 -0400
Received: by mail-pl1-f195.google.com with SMTP id c14so3299911plo.0
        for <linux-bcache@vger.kernel.org>; Fri, 28 Jun 2019 06:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ps1JjesEeWoBJv/SmzlCFFTKhOlSNgAPp3MQnR0HcHo=;
        b=xYFI5nCZ6IEgF6vvzRiCWGwdtN2xsulqWPoMGpQYGF3H2nzxzlBCr9c5MhvW6pC2g3
         1v8hWAJXtuR5mzS/fjyu/NqH5VWQNhRp3bTOZIdlKkBKsMSwlzg8FU58hsgQ+nBKcu4D
         r+dVUcLQITZlgScpWi4hVTW89qm63je0dwgVwFSidt5zZafFAptSRqmIRrJ2MIY+peLo
         31fpHTg8gtO3aiA72lz4rlhAB1wfqSNWyJgscLQ/3yXweI+FCqVFmScdcj7/o70TbyMj
         1UKlJiDB3iNTm+bAdzZUPjA+k2Xl0vYclYlFoLnzhuVNpU0bkGOSGm7ErEwEDtwx+grc
         Uf0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ps1JjesEeWoBJv/SmzlCFFTKhOlSNgAPp3MQnR0HcHo=;
        b=s1dRBAbikJyOJBYAxW5vDMb0nBh+jUwv7UqVUrAUtGVNAdQtvIWlmIve8XecYwjYEE
         W0yknnlYTmIf0CBq9Bp1vt2UBIXHt01S5H3pXLa+uXtIXfvvxKttKo6CHwsazOScu7Qg
         R6npbbgi7BTUTnjD0wiGl5qvGqet3VqSawFvN4sDJgqM+t1feX9l3AUguJXYP2WAdDXu
         algvYICPyeT5Nhy4JCY2pPyRD3sziMRDFlY+tZio5PluA4G4Axy3HF+Ro95hha9f5odZ
         5nR5LtDAmq4/IC3mdGeSLQf3FbhWkV5hEbUSJo0KHeavjMIWjSw/S+6FD6O1j4PLmHnC
         lDiA==
X-Gm-Message-State: APjAAAUugPBspK5xDwWpGjzakrVIZKF6PQJY2MnMeq+sErk2ZZkgNTKe
        RBiv7zxxnNfNjvhMBI7Y7Nhk064uV9YSJg==
X-Google-Smtp-Source: APXvYqxMLaV0cZPWp5ET6f0HzbP/GFl/8ri0BsXxvyWYCGRGpETgYwfElQ2KiV5bo/8L36AWqQqU9w==
X-Received: by 2002:a17:902:363:: with SMTP id 90mr11480810pld.340.1561729379783;
        Fri, 28 Jun 2019 06:42:59 -0700 (PDT)
Received: from [192.168.1.121] (66.29.164.166.static.utbb.net. [66.29.164.166])
        by smtp.gmail.com with ESMTPSA id i14sm4058541pfk.0.2019.06.28.06.42.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 06:42:58 -0700 (PDT)
Subject: Re: [PATCH 00/37] bcache patches for Linux v5.3
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20190628120000.40753-1-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <316a28bf-1bd4-b937-95f4-ffef77ade1c9@kernel.dk>
Date:   Fri, 28 Jun 2019 07:42:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190628120000.40753-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/28/19 5:59 AM, Coly Li wrote:
> Hi Jens,
> 
> Here are the bcache patches for Linux v5.3. All these patches are
> tested for a while and survived from my smoking and pressure testings.
> 
> This run we have Alexandru Ardelean contributes a clean up patch. The
> rested patches are from me, there is an important race fix has the
> following patches involved in,
> - bcache: Revert "bcache: free heap cache_set->flush_btree in
>    bch_journal_free"
> - bcache: Revert "bcache: fix high CPU occupancy during journal"
> - bcache: remove retry_flush_write from struct cache_set
> - bcache: fix race in btree_flush_write()
> - bcache: performance improvement for btree_flush_write()
> - bcache: add reclaimed_journal_buckets to struct cache_set
> On a Lenovo SR650 server (48 cores, 200G dram, 1T NVMe SSD as cache
> device and 12T NVMe SSD as backing device), without this fix, bcache
> can only run 40 around minutes before deadlock or panic happens. Now
> I don't observe any deadlock or panic for 5+ hours smoking test.
> 
> Please pick them for Linux v5.3, and thank you in advance.

Applied, thanks.

-- 
Jens Axboe

