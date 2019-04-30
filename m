Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06143FCDB
	for <lists+linux-bcache@lfdr.de>; Tue, 30 Apr 2019 17:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbfD3P1c (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 30 Apr 2019 11:27:32 -0400
Received: from mail-io1-f53.google.com ([209.85.166.53]:38233 "EHLO
        mail-io1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfD3P1c (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 30 Apr 2019 11:27:32 -0400
Received: by mail-io1-f53.google.com with SMTP id y6so12562135ior.5
        for <linux-bcache@vger.kernel.org>; Tue, 30 Apr 2019 08:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AozbW9bCHEY0I4T33gKXh5v6hfCjcSv3G9eLyzyu4HM=;
        b=s3sUe3aUmlFxzQhT3frfu/viBoLOVdT/qjXybgep46hfnHZrZ0h1tJ5skoN3VSn3pm
         UKmisldS7vKwD9VuVb7pXIvvWcavPKIMKDnEk5jxl9GvacIKX5Qcn6hqu9vjuv++atDI
         HrPiThyrsfOugdmIrE5lodPNmDiM63R2f0VegSVs+nJOrfbQWLfIh+q9U0FMjAVvI4Kn
         yFAOdGqpC+RjMqYwqmTkaQXED+QAeQQUgK2ud1Jq6lHW9EdXf9AeNnOR7ga3snL2Pp7W
         QX1+h7UZ3I2WiS3RRAmFJpwAtZ6p2R/SdOvCA75NygsiGqOdhdHJpKNScD9hO2piDg7V
         Ehiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AozbW9bCHEY0I4T33gKXh5v6hfCjcSv3G9eLyzyu4HM=;
        b=LhlcGNNOt+yJ5gAbicA3M2E7se26uVKfQ3/PoGT/l5E6KKBs6ejLjzKHWGSqO05li8
         3uPI4jBx9fg5dHBzJND5eHKpUfMQF9dVHafHWW1qpnQGiNE/4ZXzOyrtBjPwNQINwqMd
         bMKD33Xc/P/C7UGDa2M80jNj/rXJGAnHRjcnswEm5YVlMhSqPbPdz6yOxPBbcCwVYkJa
         DbhcJ9c/k5ndysYCCOreeY0T3x7yAXgubPqMC64r+11mvu8VxBUZYp6QGRDflw5mRope
         up69fiNWCWULWLzLmBgDeQkHvntGlTgyMCPbfOfciY45lYWEOK9TyEGtkUikA6TC1uHI
         YpSA==
X-Gm-Message-State: APjAAAX4I6RJW+YLHEGNLh5lLIeSgG1JOVQSY4H5iQYjfOIW5wzyPN22
        0sWH1m9YckUmp5rsj28uCv5hDeOH17NaQg==
X-Google-Smtp-Source: APXvYqxlpwIsrApMV8ea5Rbkrs63s/eHAjm2ZXKIT2jpDYI4EjU6/KuzpuUfeJPRqaHSIH+Gsr1nSg==
X-Received: by 2002:a6b:fe01:: with SMTP id x1mr22745182ioh.4.1556638051360;
        Tue, 30 Apr 2019 08:27:31 -0700 (PDT)
Received: from [192.168.1.158] ([216.160.245.98])
        by smtp.gmail.com with ESMTPSA id r142sm1672537itb.20.2019.04.30.08.27.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 08:27:30 -0700 (PDT)
Subject: Re: simplify bio_for_each_segment_all
To:     Christoph Hellwig <hch@lst.de>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-block@vger.kernel.org,
        linux-bcache@vger.kernel.org
References: <20190425070300.3388-1-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5a2f15d5-84cd-55d5-d580-a65b6601fe70@kernel.dk>
Date:   Tue, 30 Apr 2019 09:27:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190425070300.3388-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/25/19 1:02 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series simplifies bio_for_each_segment_all a bit, as suggested
> by willy.

Applied, thanks.

-- 
Jens Axboe

