Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFD870202
	for <lists+linux-bcache@lfdr.de>; Mon, 22 Jul 2019 16:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730701AbfGVOPh (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 22 Jul 2019 10:15:37 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41251 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730672AbfGVOPg (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 22 Jul 2019 10:15:36 -0400
Received: by mail-pg1-f196.google.com with SMTP id x15so7387416pgg.8
        for <linux-bcache@vger.kernel.org>; Mon, 22 Jul 2019 07:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c0/FaTg6NjQepjbzLVFHN8PofHop9Vbm3ERiirMsPvU=;
        b=ypAX0A/8c5Js4BXqU/PFo1onpNkeLR0Cy6r9y9LVOThDSfwyRKbt1D2aCbxkydbTyd
         a7efLs28A1J4Cdr32qvu6SZNJ84bIr4fFd+dVO6Tbz5LcPj/663dqoAzXmfd8FlFEifC
         YzefZNK7f0ghAotH/Haz0KROhQzZvJsGVbdPWHyHDL8f0DdqcqoQ2/ZprcIrq1z6ZOcv
         lbIbWgQJOsk4CTtEitBAsRtToA8f2nEEi/6chVx4HJEi3O999SFtaRfEdUnrkPDjifVR
         W5USaTvNnQg3pGL3pA9MPbKh6jAr5chXt0kKM2stqmS+NGsLyORmy0sRGjXdGD3+lAR3
         9t6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c0/FaTg6NjQepjbzLVFHN8PofHop9Vbm3ERiirMsPvU=;
        b=Gj+/f+HAcrndkZ94yxF0yRjD+VdWBlsasstMCX8Ze0PXymIeD1K9MWh0fc0QJJlcSX
         mFL4cw8DM+wxVhBpNKKTR+emy8DXpQ8KNGoGF/Uo42JEL8LIX5noBfUEa3mGKGDWets5
         V+C0ntb2wbWbMXoyAweyFsmaDrcUJdFpHL2bLbreRpjkfIXJxoU0rC8W3bmRf6Anc/+s
         cUuJGGiz2JPzwMUDmVLwRPEqy5FD8C9ojXLYMLVlUOUyHv6P8En41WxlB2pC5n4Vr+sl
         1/+6kTt4tN0FiDWneTc8w/4SXW4YKgRxfZqJ3aPQXUx7F2Nk+HQci/X0b4roU9xkGJ8O
         JmFg==
X-Gm-Message-State: APjAAAVyV066KmF3r9LzUQErCrb7kMRSAeQ6nleuHL0Ww3tACoTx9u6O
        SNJzvagd6aUwf3vCR8rO+3g=
X-Google-Smtp-Source: APXvYqyhGYBy0xc2qHSl/XSLNKe0Ob8du2ZZfvYsm0rhU3P9HY+9iwmgy9n2zOCtdFXNW0nQpb0j+g==
X-Received: by 2002:a62:6:: with SMTP id 6mr473460pfa.159.1563804936258;
        Mon, 22 Jul 2019 07:15:36 -0700 (PDT)
Received: from [192.168.1.121] (66.29.164.166.static.utbb.net. [66.29.164.166])
        by smtp.gmail.com with ESMTPSA id 23sm43424819pfn.176.2019.07.22.07.15.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 07:15:35 -0700 (PDT)
Subject: Re: [PATCH 1/1] bcache: fix possible memory leak in
 bch_cached_dev_run()
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Wei Yongjun <weiyongjun1@huawei.com>
References: <20190722141236.103967-1-colyli@suse.de>
 <20190722141236.103967-2-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5bf3c44a-6594-47e2-e4d9-6f2d9b791e2a@kernel.dk>
Date:   Mon, 22 Jul 2019 08:15:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190722141236.103967-2-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 7/22/19 8:12 AM, Coly Li wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> memory malloced in bch_cached_dev_run() and should be freed before
> leaving from the error handling cases, otherwise it will cause
> memory leak.

Applied, thanks.

-- 
Jens Axboe

